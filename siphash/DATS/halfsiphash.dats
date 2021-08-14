(*

Copyright © 2021 Barry Schwartz

This program is free software: you can redistribute it and/or
modify it under the terms of the GNU General Public License, as
published by the Free Software Foundation, either version 3 of the
License, or (at your option) any later version.

This program is distributed in the hope that it will be useful, but
WITHOUT ANY WARRANTY; without even the implied warranty of
MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
General Public License for more details.

You should have received copies of the GNU General Public License
along with this program. If not, see
<https://www.gnu.org/licenses/>.

*)

%{#
#include "siphash/CATS/siphash.cats"
%}

#define ATS_PACKNAME "ats2-siphash"
#define ATS_EXTERN_PREFIX "ats2_siphash_"

#define ATS_DYNLOADFLAG 0

#include "share/atspre_define.hats"
#include "share/atspre_staload.hats"

staload "siphash/SATS/array_prf.sats"
staload "siphash/SATS/halfsiphash.sats"

(********************************************************************)

prfn
lemma_mul_isfun {m1, n1 : int}
                {m2, n2 : int | m1 == m2; n1 == n2}
                () :<prf>
    [m1 * n1 == m2 * n2] void =
  {
    prval pf1 = mul_make {m1, n1} ()
    prval pf2 = mul_make {m2, n2} ()
    prval _ = mul_isfun {m1, n1} {m1 * n1, m2 * n2} (pf1, pf2)
  }

(********************************************************************)

extern castfn
b2u32 : byte -<> uint32

extern castfn
u2u32 : uint -<> uint32

extern castfn
sz2u32 : size_t -<> uint32

(********************************************************************)

(* A natural numbers mod function. *)
extern fn
natmod_size {x, y : nat | y != 0}
            (x    : size_t x,
             y    : size_t y) :<>
    [z : nat | z <= x; z < y; z == x mod y]
    size_t z = "mac#%"

overload natmod with natmod_size

(* Bitwise inclusive or. *)
extern fn
bitwise_ior_uint32 (x : uint32,
                    y : uint32) :<> uint32 = "mac#%"

overload bitwise_ior with bitwise_ior_uint32

(* Bitwise exclusive or. *)
extern fn
bitwise_xor_uint32 (x : uint32,
                    y : uint32) :<> uint32 = "mac#%"

overload bitwise_xor with bitwise_xor_uint32

(* Bitwise left shift, with zero-fill. *)
extern fn
bitwise_lshift_uint32_uint (x : uint32,
                            i : uint) :<> uint32 = "mac#%"

overload bitwise_lshift with bitwise_lshift_uint32_uint

(* Bitwise right shift, with zero-fill. *)
extern fn
bitwise_rshift_uint32_uint (x : uint32,
                            i : uint) :<> uint32 = "mac#%"

overload bitwise_rshift with bitwise_rshift_uint32_uint

(* Bitwise left rotation. *)
extern fn
bitwise_lrotate_uint32_uint {i : int | i < 32}
                            (x : uint32,
                             i : uint i) :<> uint32 = "mac#%"

overload bitwise_lrotate with bitwise_lrotate_uint32_uint

(* Get the uint32 at p, where the value possibly is misaligned. *)
extern fn
get32bits {p  : addr}
          (pf : !(@[byte][4] @ p) >> _ |
           p  : ptr p) :<!ref> uint32 = "mac#%"

(* Put a uint32 to p, where the value possibly is misaligned. *)
extern fn
put32bits {p  : addr}
          (pf : !(@[byte?][4] @ p) >> @[byte][4] @ p |
           p  : ptr p,
           v  : uint32) :<!refwrt> void = "mac#%"

(* On big endian platforms, swap the byte order. On little endian
   systems, do not change the value. *)
extern fn
fix_byte_order_uint32 (x : uint32) :<> uint32 = "mac#%"

overload fix_byte_order with fix_byte_order_uint32

(********************************************************************)

fn {}
siprounds {num_rounds : int}
          (num_rounds : uint num_rounds,
           v0         : uint32,
           v1         : uint32,
           v2         : uint32,
           v3         : uint32) :<>
    @(uint32, uint32, uint32, uint32) =
  let
    prval _ = lemma_g1uint_param num_rounds
    fun
    loop {n  : int | 0 <= n; n <= num_rounds} .<n>.
         (n  : uint n,
          v0 : uint32,
          v1 : uint32,
          v2 : uint32,
          v3 : uint32) :<>
        @(uint32, uint32, uint32, uint32) =
          if isgtz n then
            let
              val v0 = v0 + v1
              val v1 = bitwise_lrotate (v1, 5U)
              val v1 = bitwise_xor (v1, v0)
              val v0 = bitwise_lrotate (v0, 16U)
              val v2 = v2 + v3
              val v3 = bitwise_lrotate (v3, 8U)
              val v3 = bitwise_xor (v3, v2)
              val v0 = v0 + v3
              val v3 = bitwise_lrotate (v3, 7U)
              val v3 = bitwise_xor (v3, v0)
              val v2 = v2 + v1
              val v1 = bitwise_lrotate (v1, 13U)
              val v1 = bitwise_xor (v1, v2)
              val v2 = bitwise_lrotate (v2, 16U)
            in
              loop (pred n, v0, v1, v2, v3)
            end
          else
            @(v0, v1, v2, v3)
  in
    loop (num_rounds, v0, v1, v2, v3)
  end

fun {}
body_loop {i  : int | 0 <= i}
          {p  : addr} .<i>.
          (pf : !(@[@[byte][4]][i] @ p) >> _ |
           p  : ptr p,
           v0 : uint32,
           v1 : uint32,
           v2 : uint32,
           v3 : uint32,
           i  : size_t i) :<!ref>
    @(uint32, uint32, uint32, uint32) =
  if i2sz 0 < i then
    let
      prval _ = lemma_sizeof_array {byte} {4} ()
      prval _ =
        prop_verify {sizeof (@[byte][4]) == sizeof (byte) * 4} ()

      prval (pf_head, pf_tail) = array_v_uncons (pf)

      val m : uint32 = get32bits (pf_head | p)
      val v3 = bitwise_xor (v3, m)
      val @(v0, v1, v2, v3) =
        siprounds (halfsiphash$crounds (), v0, v1, v2, v3)
      val v0 = bitwise_xor (v0, m)

      val p = ptr_add<byte> (p, 4)
      val result =
        body_loop (pf_tail | p, v0, v1, v2, v3, pred i)

      prval _ = pf := array_v_cons (pf_head, pf_tail)
    in
      result
    end
  else
    @(v0, v1, v2, v3)

fn {}
read_what_is_left {inlen   : int}
                  {p       : addr}
                  (pf_left : !(@[byte][inlen mod 4] @ p) >> _ |
                   p       : ptr p,
                   inlen   : size_t inlen) :<!ref> uint32 =
  let
    prval _ = lemma_g1uint_param inlen

    stadef n = inlen mod 4
    val n : size_t n = natmod (inlen, i2sz 4)
    prval _ = lemma_g1uint_param n

    prval _ = prop_verify {0 <= n} ()
    prval _ = prop_verify {n < 4} ()

    fun
    loop {i       : int | 0 <= i} {p : addr} .<i>.
         (pf_left : !(@[byte][i] @ p) >> _ |
          p       : ptr p,
          b       : uint32,
          i       : uint i) :<!ref> uint32 =
      if 0U < i then
        let
          val j = pred i
          prval (pf1, pf_elem) = array_v_unextend pf_left
          val elem = ptr_get<byte> (pf_elem | ptr_add<byte> (p, j))
          val term = bitwise_lshift (b2u32 elem, j * 8U)
          val result = loop (pf1 | p, bitwise_ior (b, term), j)
          prval _ = pf_left := array_v_extend (pf1, pf_elem)
        in
          result
        end
      else
        b
  in
    loop (pf_left | p, bitwise_lshift (sz2u32 inlen, 24U), sz2u n)
  end

fn {}
halfsiphash_vtuple {inlen  : int}
               {outlen : int | outlen == 4 || outlen == 8}
               (input  : &RD(@[byte][inlen]),
                inlen  : size_t inlen,
                key    : &RD(@[byte][8]),
                outlen : size_t outlen) :<!ref>
    @(uint32, uint32, uint32, uint32) =
  let
    prval _ = lemma_g1uint_param inlen

    val v0 : uint32 = $UNSAFE.cast 0
    val v1 : uint32 = $UNSAFE.cast 0
    val v2 : uint32 = $UNSAFE.cast 0x6c796765UL
    val v3 : uint32 = $UNSAFE.cast 0x74656462UL

    prval (pf_key0, pf_key1) =
      array_v_subdivide2 {..} {..} {4, 4} (view@ key)
    val k0 = get32bits (pf_key0 | addr@ key)
    val k1 = get32bits (pf_key1 | ptr_add<byte> (addr@ key, 4))
    prval _ = view@ key := array_v_join2 (pf_key0, pf_key1)

    stadef count = inlen / 4
    val count = inlen / (i2sz 4)

    prval _ = prop_verify {inlen mod 4 == inlen - (count * 4)} ()

    val v3 = bitwise_xor (v3, k1)
    val v2 = bitwise_xor (v2, k0)
    val v1 = bitwise_xor (v1, k1)
    val v0 = bitwise_xor (v0, k0)

    val v1 =
      if outlen = i2sz 8 then
        bitwise_xor (v1, u2u32 0xeeU)
      else
        v1

    stadef body_size = count * 4
    val body_size : size_t body_size = count * (i2sz 4)

    (* Split the input into a body and what-is-left after the body. *)
    prval (pf_body, pf_what_is_left) =
      array_v_subdivide2 {byte} {..} {body_size, inlen mod 4}
                         (view@ input)

    (* View the body as an array of 4-byte arrays. *)
    prval pf_fours = array_v_group {byte} {..} {count, 4} (pf_body)
    val @(v0, v1, v2, v3) =
      body_loop (pf_fours | addr@ input, v0, v1, v2, v3, count)
    prval _ = pf_body := array_v_ungroup (pf_fours)

    (* Deal with whatever bytes are left over after the body. *)
    val [num_bytes_left : int] num_bytes_left = natmod (inlen, i2sz 4)
    prval _ = lemma_mul_isfun {inlen - num_bytes_left, sizeof (byte)}
                              {(inlen / 4) * 4, sizeof (byte)} ()
    val p_what_is_left = ptr_add<byte> (addr@ input, inlen - num_bytes_left)
    val b = read_what_is_left (pf_what_is_left | p_what_is_left, inlen)

    prval _ = view@ input := array_v_join2 (pf_body, pf_what_is_left)

    val v3 = bitwise_xor (v3, b)

    val @(v0, v1, v2, v3) =
      siprounds (halfsiphash$crounds (), v0, v1, v2, v3)

    val v0 = bitwise_xor (v0, b)

    val v2 = bitwise_xor (v2, (if outlen = i2sz 8 then
                                 u2u32 0xeeU
                               else
                                 u2u32 0xffU))
        
    val @(v0, v1, v2, v3) =
      siprounds (halfsiphash$drounds (), v0, v1, v2, v3)
  in
    @(v0, v1, v2, v3)
  end

implement {}
halfsiphash_32 (input, inlen, key) =
  let
    val @(v0, v1, v2, v3) = halfsiphash_vtuple (input, inlen, key, i2sz 4)
  in
    bitwise_xor (v1, v3)
  end

implement {}
halfsiphash_64 (input, inlen, key) =
  let
    val @(v0, v1, v2, v3) =
      halfsiphash_vtuple (input, inlen, key, i2sz 8)

    val hashval1 = bitwise_xor (v1, v3)

    val v1 = bitwise_xor (v1, u2u32 0xddU)
    val @(v0, v1, v2, v3) =
      siprounds (halfsiphash$drounds (), v0, v1, v2, v3)

    val hashval2 = bitwise_xor (v1, v3)
  in
    @(hashval1, hashval2)
  end

implement {}
halfsiphash (input, inlen, key, output, outlen) =
  if outlen = i2sz 4 then
    {
      val hashval = halfsiphash_32 (input, inlen, key)
      val _ = put32bits (view@ output | addr@ output, hashval)
    }
  else
    {
      val (hashval1, hashval2) = halfsiphash_64 (input, inlen, key)
      prval (pf1, pf2) =
        array_v_subdivide2 {..} {..} {4, 4} (view@ output)
      val _ = put32bits (pf1 | addr@ output, hashval1)
      val _ = put32bits (pf2 | ptr_add<byte> (addr@ output, 4),
                               hashval2)
      prval _ = view@ output := array_v_join2 (pf1, pf2)
    }

(********************************************************************)
