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
#include <string.h>
%}

#define ATS_PACKNAME "ats2-siphash"
#define ATS_EXTERN_PREFIX "ats2_siphash_"

#define ATS_DYNLOADFLAG 0

#include "share/atspre_define.hats"
#include "share/atspre_staload.hats"

staload "siphash/SATS/array_prf.sats"
staload "siphash/SATS/siphash.sats"
staload "tests/vectors.sats"

prval _ = lemma_sizeof_array {byte} {8} ()

fn
put_uint64 (bytes : &(@[byte][8]),
            value : &uint64) : void =
  $extfcall (void, "memcpy", addr@ bytes, addr@ value, i2sz 8)

fn
compare_bytes {n      : int}
              (bytes1 : &(@[byte][n]),
               bytes2 : &(@[byte][n]),
               n      : size_t n) : int =
  $extfcall (int, "memcmp", addr@ bytes1, addr@ bytes2, n)

fn
check_bytes {n      : int}
            (bytes1 : &(@[byte][n]),
             bytes2 : &(@[byte][n]),
             n      : size_t n) : bool =
  (compare_bytes (bytes1, bytes2, n) = 0)

fn
initialize_bytes {n     : int}
                 (bytes : &(@[byte?][n]) >> @[byte][n],
                  n     : size_t n) : void =
  let
    implement
    array_initize$init<byte> (i, x) =
      x := $UNSAFE.cast{byte} (i)
  in
    array_initize<byte> (bytes, n)
  end

fn
test_siphash_2_4_64 () : void =
  {
    fun
    loop {i : int | 0 <= i; i <= 64} .<64 - i>.
         (i : size_t i) : void =
      if i < i2sz 64 then
        {
          var key : @[byte][16]
          val _ = initialize_bytes (key, i2sz 16)

          var input : @[byte][64]
          val _ = initialize_bytes (input, i2sz 64)

          prval (pf_inp1, pf_inp2) =
            array_v_subdivide2 {byte} {..} {i, 64 - i} (view@ input)

          var h = siphash_2_4_64 (!(addr@ input), i, key)
          var output = @[byte][8] (i2byte 0)
          val _ = put_uint64 (output, h)

          val (pf_vecs, consume_pf_vecs | p_vecs) = vectors_sip64 ()
          prval (pf_left, pf_vec, pf_right) =
            array_v_subdivide3 {byte} {..}
                               {i * 8, 8, 512 - i * 8 - 8}
                               (pf_vecs)

          val p_vec = ptr_add<byte> (p_vecs, i * i2sz 8)

          val _ = assertloc (check_bytes (!p_vec, output, i2sz 8))

          prval _ =
            pf_vecs := array_v_join3 (pf_left, pf_vec, pf_right)
          prval _ = consume_pf_vecs pf_vecs

          prval _ = view@ input := array_v_join2 (pf_inp1, pf_inp2)
        }

    val _ = loop (i2sz 0)
  }

implement
main0 () =
  begin
    test_siphash_2_4_64 ()
  end
