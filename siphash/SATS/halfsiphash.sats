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

(********************************************************************)
(*
  HalfSipHash

  See
  https://en.wikipedia.org/w/index.php?title=SipHash&oldid=1032799115
*)

(*------------------------------------------------------------------*)
(*
  Setting crounds and drounds by template rather than passing
  them as parameters might help the C compiler unroll loops.
*)

(* Use this to set the crounds. *)
fun {}
halfsiphash$crounds () :<> [crounds : pos] uint crounds

(* Use this to set the drounds. *)
fun {}
halfsiphash$drounds () :<> [drounds : pos] uint drounds

(*------------------------------------------------------------------*)

fun {}
halfsiphash_32
        {inlen  : int}
        (input  : &RD(@[byte][inlen]),
         inlen  : size_t inlen,
         key    : &RD(@[byte][8])) :<!ref> uint32

fun {}
halfsiphash_64
        {inlen  : int}
        (input  : &RD(@[byte][inlen]),
         inlen  : size_t inlen,
         key    : &RD(@[byte][8])) :<!ref> @(uint32, uint32)

(* The following template reproduces the "halfsiphash" function of
   the reference implementation, except that it returns no value
   and can have its crounds and drounds tailored. *)
fun {}
halfsiphash
        {inlen  : int}
        {outlen : int | outlen == 4 || outlen == 8}
        (input  : &RD(@[byte][inlen]),
         inlen  : size_t inlen,
         key    : &RD(@[byte][8]),
         output : &(@[byte?][outlen]) >> @[byte][outlen],
         outlen : size_t outlen) :<!refwrt> void

(********************************************************************)

#include "siphash/SATS/include/halfsiphash-implementations.inc"

(********************************************************************)
