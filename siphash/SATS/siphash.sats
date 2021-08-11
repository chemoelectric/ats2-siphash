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
  SipHash

  See
  https://en.wikipedia.org/w/index.php?title=SipHash&oldid=1032799115
*)

(* Use this to set the crounds. *)
fun {}
siphash$crounds () :<> [crounds : pos] uint crounds

(* Use this to set the drounds. *)
fun {}
siphash$drounds () :<> [drounds : pos] uint drounds

fun {}
siphash_64 {inlen  : int}
           (input  : &RD(@[byte][inlen]),
            inlen  : size_t inlen,
            key    : &RD(@[byte][16])) :<!ref> uint64

fun {}
siphash_128 {inlen  : int}
            (input  : &RD(@[byte][inlen]),
             inlen  : size_t inlen,
             key    : &RD(@[byte][16])) :<!ref> @(uint64, uint64)

(* The following template reproduces the "siphash" function of
   the reference implementation, except that it returns no value
   and can have its crounds and drounds tailored. *)
fun {}
siphash {inlen  : int}
        {outlen : int | outlen == 8 || outlen == 16}
        (input  : &RD(@[byte][inlen]),
         inlen  : size_t inlen,
         key    : &RD(@[byte][16]),
         output : &(@[byte?][outlen]) >> @[byte][outlen],
         outlen : size_t outlen) :<!refwrt> void

(********************************************************************)

fun
siphash_2_4_64 {inlen  : int}
               (input  : &RD(@[byte][inlen]),
                inlen  : size_t inlen,
                key    : &RD(@[byte][16])) :<!ref> uint64

fun
siphash_4_8_64 {inlen  : int}
               (input  : &RD(@[byte][inlen]),
                inlen  : size_t inlen,
                key    : &RD(@[byte][16])) :<!ref> uint64

fun
siphash_2_4_128 {inlen  : int}
                (input  : &RD(@[byte][inlen]),
                 inlen  : size_t inlen,
                 key    : &RD(@[byte][16])) :<!ref> @(uint64, uint64)

fun
siphash_4_8_128 {inlen  : int}
                (input  : &RD(@[byte][inlen]),
                 inlen  : size_t inlen,
                 key    : &RD(@[byte][16])) :<!ref> @(uint64, uint64)

fun
siphash_2_4_output
        {inlen  : int}
        {outlen : int | outlen == 8 || outlen == 16}
        (input  : &RD(@[byte][inlen]),
         inlen  : size_t inlen,
         key    : &RD(@[byte][16]),
         output : &(@[byte?][outlen]) >> @[byte][outlen],
         outlen : size_t outlen) :<!refwrt> void

fun
siphash_4_8_output
        {inlen  : int}
        {outlen : int | outlen == 8 || outlen == 16}
        (input  : &RD(@[byte][inlen]),
         inlen  : size_t inlen,
         key    : &RD(@[byte][16]),
         output : &(@[byte?][outlen]) >> @[byte][outlen],
         outlen : size_t outlen) :<!refwrt> void

overload siphash_2_4 with siphash_2_4_64
overload siphash_2_4 with siphash_2_4_output

overload siphash_4_8 with siphash_4_8_64
overload siphash_4_8 with siphash_4_8_output

(********************************************************************)

