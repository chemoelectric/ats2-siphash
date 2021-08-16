/*

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

*/

include(`common-macros.m4')

%{#
#include <string.h>
%}

#define ATS_PACKNAME "ats2-siphash"
#define ATS_EXTERN_PREFIX "ats2_siphash_"

#define ATS_DYNLOADFLAG 0

#include "share/atspre_define.hats"
#include "share/atspre_staload.hats"

staload "siphash/SATS/key.sats"
staload "siphash/SATS/siphash.sats"
staload "siphash/SATS/halfsiphash.sats"

fn {t : vt@ype}
make_pf_view {p : addr} {n : int} (p : ptr p, n : size_t n) :<>
    (@[t][n] @ p, @[t][n] @ p -<lin,prf> void | ptr p) =
  let
    extern praxi {t : vt@ype}
    make_view : {p : addr} {n : int} () -<prf> @[t][n] @ p
    extern praxi {t : vt@ype}
    make_consume_view :
      {p : addr} {n : int} () -<prf>
        (@[t][n] @ p) -<lin,prf> void
  in
    (make_view<t> {p} {n} (),
     make_consume_view<t> {p} {n} () |
     p)
  end

fn
print_bytes {n     : int}
            (bytes : &(@[byte][n]),
             n     : size_t n) : void =
  let
    prval _ = lemma_g1uint_param n
    var j : [j : int | 0 <= j; j <= n] size_t j
  in
    for (j := i2sz 0; j < n; j := succ j)
      {
        val elem = bytes[j]
        val _ =
          if isgtz j then
            {
              val _ = $extfcall (int, "printf", " ")
            }
        val _ = $extfcall (int, "printf", "%02X",
                           byte2int0 elem)
      }
  end

fn
bytes_equal {n      : int}
            (bytes1 : &(@[byte][n]),
             bytes2 : &(@[byte][n]),
             n      : size_t n) : bool =
  $extfcall (int, "memcmp", addr@ bytes1, addr@ bytes2, n) = 0

fn
string2bytes {n : int}
             (s : string n) :
    [p : addr]
    (@[byte][n] @ p,
     @[byte][n] @ p -<lin,prf> void |
     ptr p,
     size_t n) =
  let
    val [p : addr] p = string2ptr s
    val n = strlen s
    val (pf_view, consume_pf_view | p) = make_pf_view<byte> (p, n)
  in
    (pf_view, consume_pf_view | p, n)
  end

fn
test_siphash_keys_equal () : void =
  {
    val (pf_key1, consume_pf_key1 | key1) = siphash_key ()
    val (pf_key2, consume_pf_key2 | key2) = siphash_key ()
    val (pf_key3, consume_pf_key3 | key3) = siphash_key ()
    val (pf_key4, consume_pf_key4 | key4) = siphash_key ()

    val _ = assertloc (bytes_equal (!key1, !key2, i2sz 16))
    val _ = assertloc (bytes_equal (!key1, !key3, i2sz 16))
    val _ = assertloc (bytes_equal (!key1, !key4, i2sz 16))

    val _ = $extfcall (int, "printf", "siphash_key ()       ")
    val _ = print_bytes (!key1, i2sz 16)
    val _ = $extfcall (int, "printf", "\n")

    prval _ = consume_pf_key1 pf_key1
    prval _ = consume_pf_key2 pf_key2
    prval _ = consume_pf_key3 pf_key3
    prval _ = consume_pf_key4 pf_key4
  }

fn
test_halfsiphash_keys_equal () : void =
  {
    val (pf_key1, consume_pf_key1 | key1) = halfsiphash_key ()
    val (pf_key2, consume_pf_key2 | key2) = halfsiphash_key ()
    val (pf_key3, consume_pf_key3 | key3) = halfsiphash_key ()
    val (pf_key4, consume_pf_key4 | key4) = halfsiphash_key ()

    val _ = assertloc (bytes_equal (!key1, !key2, i2sz 8))
    val _ = assertloc (bytes_equal (!key1, !key3, i2sz 8))
    val _ = assertloc (bytes_equal (!key1, !key4, i2sz 8))

    val _ = $extfcall (int, "printf", "halfsiphash_key ()   ")
    val _ = print_bytes (!key1, i2sz 8)
    val _ = $extfcall (int, "printf", "\n")

    prval _ = consume_pf_key1 pf_key1
    prval _ = consume_pf_key2 pf_key2
    prval _ = consume_pf_key3 pf_key3
    prval _ = consume_pf_key4 pf_key4
  }

fn
use_siphash_key () : void =
  {
    val (pf_key, consume_pf_key | key) = siphash_key ()

    val s1 = "hash1 test"
    val (pf_p1, consume_pf_p1 | p1, n1) = string2bytes s1
    val hash1a = siphash_2_4 (!p1, n1, !key)
    val hash1b = siphash_2_4 (!p1, n1, !key)
    val hash1c = siphash_2_4 (!p1, n1, !key)
    val hash1d = siphash_2_4 (!p1, n1, !key)
    val _ = assertloc (hash1a = hash1b)
    val _ = assertloc (hash1a = hash1c)
    val _ = assertloc (hash1a = hash1d)
    val _ = println! ("siphash of \"", s1, "\" = ", hash1a)
    prval _ = consume_pf_p1 pf_p1

    val s2 = "hash2 test"
    val (pf_p2, consume_pf_p2 | p2, n2) = string2bytes s2
    val hash2a = siphash_2_4 (!p2, n2, !key)
    val hash2b = siphash_2_4 (!p2, n2, !key)
    val hash2c = siphash_2_4 (!p2, n2, !key)
    val hash2d = siphash_2_4 (!p2, n2, !key)
    val _ = assertloc (hash2a = hash2b)
    val _ = assertloc (hash2a = hash2c)
    val _ = assertloc (hash2a = hash2d)
    val _ = println! ("siphash of \"", s2, "\" = ", hash2a)
    prval _ = consume_pf_p2 pf_p2

    prval _ = consume_pf_key pf_key
  }

fn
use_halfsiphash_key () : void =
  {
    val (pf_key, consume_pf_key | key) = halfsiphash_key ()

    val s1 = "hash1 test"
    val (pf_p1, consume_pf_p1 | p1, n1) = string2bytes s1
    val hash1a = halfsiphash_2_4 (!p1, n1, !key)
    val hash1b = halfsiphash_2_4 (!p1, n1, !key)
    val hash1c = halfsiphash_2_4 (!p1, n1, !key)
    val hash1d = halfsiphash_2_4 (!p1, n1, !key)
    val _ = assertloc (hash1a = hash1b)
    val _ = assertloc (hash1a = hash1c)
    val _ = assertloc (hash1a = hash1d)
    val _ = println! ("halfsiphash of \"", s1, "\" = ", hash1a)
    prval _ = consume_pf_p1 pf_p1

    val s2 = "hash2 test"
    val (pf_p2, consume_pf_p2 | p2, n2) = string2bytes s2
    val hash2a = halfsiphash_2_4 (!p2, n2, !key)
    val hash2b = halfsiphash_2_4 (!p2, n2, !key)
    val hash2c = halfsiphash_2_4 (!p2, n2, !key)
    val hash2d = halfsiphash_2_4 (!p2, n2, !key)
    val _ = assertloc (hash2a = hash2b)
    val _ = assertloc (hash2a = hash2c)
    val _ = assertloc (hash2a = hash2d)
    val _ = println! ("halfsiphash of \"", s2, "\" = ", hash2a)
    prval _ = consume_pf_p2 pf_p2

    prval _ = consume_pf_key pf_key
  }

implement
main0 () =
  {
    val _ = test_siphash_keys_equal ()
    val _ = test_halfsiphash_keys_equal ()
    val _ = use_siphash_key ()
    val _ = use_halfsiphash_key ()
  }
