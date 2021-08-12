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

#define ATS_PACKNAME "ats2-siphash"
#define ATS_EXTERN_PREFIX "ats2_siphash_"

#define ATS_DYNLOADFLAG 0

#include "share/atspre_define.hats"
#include "share/atspre_staload.hats"

staload SH = "siphash/SATS/siphash.sats"

(* A variant of ‘orelse’, with dependent types. *)
fn {}
orelse1 {b1, b2 : bool} (b1 : bool b1, b2 : bool b2) :<>
    [b3 : bool | b3 == (b1 || b2)] bool b3 =
  if b1 then
    true
  else
    b2

infixl (||) |||
macdef ||| = orelse1

typedef constptr (p : addr) = $extype"const void *"
typedef constsize (n : int) = $extype"const size_t"

extern castfn
constptr2ptr :
  {p : addr} constptr p -<> ptr p

extern castfn
constsize2size :
  {n : int} constsize n -<> size_t n

extern praxi
make_view :
  {p : addr; n : int} (ptr p) -<prf>
    (@[byte][n] @ p, @[byte][n] @ p -<lin,prf> void | ptr p)

extern fn
siphash_2_4 {inlen  : int}
            {outlen : int}
            {pi, pk, po : addr}
            (input  : constptr pi,
             inlen  : constsize inlen,
             key    : constptr pk,
             output : ptr po,
             outlen : constsize outlen) : void

extern fn
siphash_4_8 {inlen  : int}
            {outlen : int}
            {pi, pk, po : addr}
            (input  : constptr pi,
             inlen  : constsize inlen,
             key    : constptr pk,
             output : ptr po,
             outlen : constsize outlen) : void

extern fn
siphash_c_d {inlen   : int}
            {outlen  : int}
            {pi, pk, po : addr}
            (input   : constptr pi,
             inlen   : constsize inlen,
             key     : constptr pk,
             crounds : uint,
             drounds : uint,
             output  : ptr po,
             outlen  : constsize outlen) : void

implement
siphash_2_4 {inlen} {outlen} {pi, pk, po}
            (input, inlen, key, output, outlen) =
  {
    val inlen = constsize2size inlen
    val outlen = constsize2size outlen
    val _ = assertloc (outlen = i2sz 8 ||| outlen = i2sz 16)

    val input = constptr2ptr input
    val key = constptr2ptr key

    val (pf_input, consume_pf_input | input) =
      make_view {pi, inlen} (input)
    val (pf_key, consume_pf_key | key) =
      make_view {pk, 16} (key)
    val (pf_output, consume_pf_output | output) =
      make_view {po, outlen} (output)

    val _ = $SH.siphash_2_4_output (!input, inlen, !key,
                                    !output, outlen)

    prval _ = consume_pf_input pf_input
    prval _ = consume_pf_key pf_key
    prval _ = consume_pf_output pf_output
  }

implement
siphash_4_8 {inlen} {outlen} {pi, pk, po}
            (input, inlen, key, output, outlen) =
  {
    val inlen = constsize2size inlen
    val outlen = constsize2size outlen
    val _ = assertloc (outlen = i2sz 8 ||| outlen = i2sz 16)

    val input = constptr2ptr input
    val key = constptr2ptr key

    val (pf_input, consume_pf_input | input) =
      make_view {pi, inlen} (input)
    val (pf_key, consume_pf_key | key) =
      make_view {pk, 16} (key)
    val (pf_output, consume_pf_output | output) =
      make_view {po, outlen} (output)

    val _ = $SH.siphash_4_8_output (!input, inlen, !key,
                                    !output, outlen)

    prval _ = consume_pf_input pf_input
    prval _ = consume_pf_key pf_key
    prval _ = consume_pf_output pf_output
  }

implement
siphash_c_d {inlen} {outlen} {pi, pk, po}
            (input, inlen, key, crounds, drounds, output, outlen) =
  {
    val inlen = constsize2size inlen
    val outlen = constsize2size outlen
    val _ = assertloc (outlen = i2sz 8 ||| outlen = i2sz 16)

    val input = constptr2ptr input
    val key = constptr2ptr key

    val (pf_input, consume_pf_input | input) =
      make_view {pi, inlen} (input)
    val (pf_key, consume_pf_key | key) =
      make_view {pk, 16} (key)
    val (pf_output, consume_pf_output | output) =
      make_view {po, outlen} (output)

    val crounds = g1ofg0 crounds
    val drounds = g1ofg0 drounds
    val _ = assertloc (1U <= crounds)
    val _ = assertloc (1U <= drounds)

    val _ = $SH.siphash_c_d_output (!input, inlen, !key,
                                    crounds, drounds,
                                    !output, outlen)

    prval _ = consume_pf_input pf_input
    prval _ = consume_pf_key pf_key
    prval _ = consume_pf_output pf_output
  }
