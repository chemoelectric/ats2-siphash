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
staload "siphash/SATS/siphash.sats"

(********************************************************************)

(*
prfn
mul_compare_lte {i, j, n : nat | i <= j} () :<prf>
    [i * n <= j * n] void =
  mul_gte_gte_gte {j - i, n} ()

prfn
lemma_mul_is_associative {x, y, z : int} () :<prf>
    [(x * y) * z == x * (y * z)] void =
  ()
*)

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

(*
prfn
lemma_indexing_by_group {t : vt@ype}
                        {i, group_size : int}
                        () :<prf>
    [(i * group_size) * sizeof (t) == i * sizeof (@[t][group_size])]
    void =
  {
    prval _ = lemma_sizeof_array {t} {group_size} ()
    prval _ = lemma_mul_is_associative {i, group_size, sizeof (t)} ()
    prval _ = lemma_mul_isfun {i, sizeof (@[t][group_size])}
                              {i, group_size * sizeof (t)} ()
  }
*)

(********************************************************************)

extern castfn
b2u64 : byte -<> uint64

extern castfn
u2u64 : uint -<> uint64

extern castfn
sz2u64 : size_t -<> uint64

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
bitwise_ior_uint64 (x : uint64,
                    y : uint64) :<> uint64 = "mac#%"

overload bitwise_ior with bitwise_ior_uint64

(* Bitwise exclusive or. *)
extern fn
bitwise_xor_uint64 (x : uint64,
                    y : uint64) :<> uint64 = "mac#%"

overload bitwise_xor with bitwise_xor_uint64

(* Bitwise left shift, with zero-fill. *)
extern fn
bitwise_lshift_uint64_uint (x : uint64,
                            i : uint) :<> uint64 = "mac#%"

overload bitwise_lshift with bitwise_lshift_uint64_uint

(* Bitwise right shift, with zero-fill. *)
extern fn
bitwise_rshift_uint64_uint (x : uint64,
                            i : uint) :<> uint64 = "mac#%"

overload bitwise_rshift with bitwise_rshift_uint64_uint

(* Bitwise left rotation. *)
extern fn
bitwise_lrotate_uint64_uint {i : int | i < 64}
                            (x : uint64,
                             i : uint i) :<> uint64 = "mac#%"

overload bitwise_lrotate with bitwise_lrotate_uint64_uint

(* Get the uint64 at p, where the value possibly is misaligned. *)
extern fn
get64bits {p  : addr}
          (pf : !(@[byte][8] @ p) >> _ |
           p  : ptr p) :<!ref> uint64 = "mac#%"

(* Put a uint64 to p, where the value possibly is misaligned. *)
extern fn
put64bits {p  : addr}
          (pf : !(@[byte?][8] @ p) >> @[byte][8] @ p |
           p  : ptr p,
           v  : uint64) :<!refwrt> void = "mac#%"

(* On big endian platforms, swap the byte order. On little endian
   systems, do not change the value. *)
extern fn
fix_byte_order_uint64 (x : uint64) :<> uint64 = "mac#%"

overload fix_byte_order with fix_byte_order_uint64

(********************************************************************)

implement {}
siphash$crounds () = 2U

implement {}
siphash$drounds () = 4U

(********************************************************************)

fn {}
siprounds {num_rounds : int}
          (num_rounds : uint num_rounds,
           v0         : uint64,
           v1         : uint64,
           v2         : uint64,
           v3         : uint64) :<>
    @(uint64, uint64, uint64, uint64) =
  let
    prval _ = lemma_g1uint_param num_rounds
    fun
    loop {n  : int | 0 <= n; n <= num_rounds} .<n>.
         (n  : uint n,
          v0 : uint64,
          v1 : uint64,
          v2 : uint64,
          v3 : uint64) :<>
        @(uint64, uint64, uint64, uint64) =
          if isgtz n then
            let
              val v0 = v0 + v1
              val v1 = bitwise_lrotate (v1, 13U)
              val v1 = bitwise_xor (v1, v0)
              val v0 = bitwise_lrotate (v0, 32U)
              val v2 = v2 + v3
              val v3 = bitwise_lrotate (v3, 16U)
              val v3 = bitwise_xor (v3, v2)
              val v0 = v0 + v3
              val v3 = bitwise_lrotate (v3, 21U)
              val v3 = bitwise_xor (v3, v0)
              val v2 = v2 + v1
              val v1 = bitwise_lrotate (v1, 17U)
              val v1 = bitwise_xor (v1, v2)
              val v2 = bitwise_lrotate (v2, 32U)
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
          (pf : !(@[@[byte][8]][i] @ p) >> _ |
           p  : ptr p,
           v0 : uint64,
           v1 : uint64,
           v2 : uint64,
           v3 : uint64,
           i  : size_t i) :<!ref>
    @(uint64, uint64, uint64, uint64) =
  if i2sz 0 < i then
    let
      prval _ = lemma_sizeof_array {byte} {8} ()
      prval _ =
        prop_verify {sizeof (@[byte][8]) == sizeof (byte) * 8} ()

      prval (pf_head, pf_tail) = array_v_uncons (pf)

      val m : uint64 = get64bits (pf_head | p)
      val v3 = bitwise_xor (v3, m)
      val @(v0, v1, v2, v3) = siprounds (siphash$crounds (),
                                         v0, v1, v2, v3)
      val v0 = bitwise_xor (v0, m)

      val p = ptr_add<byte> (p, 8)
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
                  (pf_left : !(@[byte][inlen mod 8] @ p) >> _ |
                   p       : ptr p,
                   inlen   : size_t inlen) :<!ref> uint64 =
  let
    prval _ = lemma_g1uint_param inlen

    stadef n = inlen mod 8
    val n : size_t n = natmod (inlen, i2sz 8)
    prval _ = lemma_g1uint_param n

    prval _ = prop_verify {0 <= n} ()
    prval _ = prop_verify {n < 8} ()

    fun
    loop {i       : int | 0 <= i} {p : addr} .<i>.
         (pf_left : !(@[byte][i] @ p) >> _ |
          p       : ptr p,
          b       : uint64,
          i       : uint i) :<!ref> uint64 =
      if 0U < i then
        let
          val j = pred i
          prval (pf1, pf_elem) = array_v_unextend pf_left
          val elem = ptr_get<byte> (pf_elem | ptr_add<byte> (p, j))
          val term = bitwise_lshift (b2u64 elem, j * 8U)
          val result = loop (pf1 | p, bitwise_ior (b, term), j)
          prval _ = pf_left := array_v_extend (pf1, pf_elem)
        in
          result
        end
      else
        b
  in
    loop (pf_left | p, bitwise_lshift (sz2u64 inlen, 56U), sz2u n)
  end

fn {}
siphash_vtuple {inlen  : int}
               {outlen : int | outlen == 8 || outlen == 16}
               (input  : &RD(@[byte][inlen]),
                inlen  : size_t inlen,
                key    : &RD(@[byte][16]),
                outlen : size_t outlen) :<!ref>
    @(uint64, uint64, uint64, uint64) =
  let
    prval _ = lemma_sizeof_array {byte} {8} ()
    prval _ =
      prop_verify {sizeof (@[byte][8]) == sizeof (byte) * 8} ()

    prval _ = lemma_g1uint_param inlen

    val v0 : uint64 = $UNSAFE.cast 0x736f6d6570736575ULL
    val v1 : uint64 = $UNSAFE.cast 0x646f72616e646f6dULL
    val v2 : uint64 = $UNSAFE.cast 0x6c7967656e657261ULL
    val v3 : uint64 = $UNSAFE.cast 0x7465646279746573ULL

    prval (pf_key0, pf_key1) =
      array_v_subdivide2 {..} {..} {8, 8} (view@ key)
    val k0 = get64bits (pf_key0 | addr@ key)
    val k1 = get64bits (pf_key1 | ptr_add<byte> (addr@ key, 8))
    prval _ = view@ key := array_v_join2 (pf_key0, pf_key1)

    stadef count = inlen / 8
    val count = inlen / (i2sz 8)

    prval _ = prop_verify {inlen mod 8 == inlen - (count * 8)} ()

    val v3 = bitwise_xor (v3, k1)
    val v2 = bitwise_xor (v2, k0)
    val v1 = bitwise_xor (v1, k1)
    val v0 = bitwise_xor (v0, k0)

    val v1 =
      if outlen = i2sz 16 then
        bitwise_xor (v1, u2u64 0xeeU)
      else
        v1

    stadef body_size = count * 8
    val body_size : size_t body_size = count * (i2sz 8)

    (* Split the input into a body and what-is-left after the body. *)
    prval (pf_body, pf_what_is_left) =
      array_v_subdivide2 {byte} {..} {body_size, inlen mod 8}
                         (view@ input)

    (* View the body as an array of 8-byte arrays. *)
    prval pf_eights = array_v_group {byte} {..} {count, 8} (pf_body)
    val @(v0, v1, v2, v3) =
      body_loop (pf_eights | addr@ input, v0, v1, v2, v3, count)
    prval _ = pf_body := array_v_ungroup (pf_eights)

    (* Deal with whatever bytes are left over after the body. *)
    val [num_bytes_left : int] num_bytes_left = natmod (inlen, i2sz 8)
    prval _ = lemma_mul_isfun {inlen - num_bytes_left, sizeof (byte)}
                              {(inlen / 8) * 8, sizeof (byte)} ()
    val p_what_is_left = ptr_add<byte> (addr@ input, inlen - num_bytes_left)
    val b = read_what_is_left (pf_what_is_left | p_what_is_left, inlen)

    prval _ = view@ input := array_v_join2 (pf_body, pf_what_is_left)

    val v3 = bitwise_xor (v3, b)

    val @(v0, v1, v2, v3) = siprounds (siphash$crounds (),
                                       v0, v1, v2, v3)

    val v0 = bitwise_xor (v0, b)

    val v2 = bitwise_xor (v2, (if outlen = i2sz 16 then
                                 u2u64 0xeeU
                               else
                                 u2u64 0xffU))
        
    val @(v0, v1, v2, v3) = siprounds (siphash$drounds (),
                                       v0, v1, v2, v3)
  in
    @(v0, v1, v2, v3)
  end

implement {}
siphash_64 (input, inlen, key) =
  let
    val @(v0, v1, v2, v3) = siphash_vtuple (input, inlen, key, i2sz 8)
  in
    bitwise_xor (bitwise_xor (bitwise_xor (v0, v1), v2), v3)
  end

implement {}
siphash_128 (input, inlen, key) =
  let
    val @(v0, v1, v2, v3) =
      siphash_vtuple (input, inlen, key, i2sz 16)

    val hashval1 =
      bitwise_xor (bitwise_xor (bitwise_xor (v0, v1), v2), v3)

    val v1 = bitwise_xor (v1, u2u64 0xddU)
    val @(v0, v1, v2, v3) = siprounds (siphash$drounds (),
                                       v0, v1, v2, v3)

    val hashval2 =
      bitwise_xor (bitwise_xor (bitwise_xor (v0, v1), v2), v3)
  in
    @(hashval1, hashval2)
  end

implement {}
siphash (input, inlen, key, output, outlen) =
  if outlen = i2sz 8 then
    {
      val hashval = siphash_64 (input, inlen, key)
      val _ = put64bits (view@ output | addr@ output, hashval)
    }
  else
    {
      val (hashval1, hashval2) = siphash_128 (input, inlen, key)
      prval (pf1, pf2) =
        array_v_split {..} {..} {16} {8} (view@ output)
      val _ = put64bits (pf1 | addr@ output, hashval1)
      val _ = put64bits (pf2 | ptr_add<byte> (addr@ output, 8),
                               hashval2)
      prval _ = view@ output := array_v_unsplit (pf1, pf2)
    }

(********************************************************************)
