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

%{#
#include "siphash/CATS/siphash.cats"
#include "siphash/CATS/key.cats"
%}

(********************************************************************)

(* Randomly generate a key of given length. *)
fun
make_key {keylen : int | keylen <= 256}
         (key    : &(@[byte?][keylen]) >> @[byte][keylen],
          keylen : size_t keylen) :<!refwrt> void

(* Return a pointer to a one-time-initialized key of length 128. *)
fun
siphash_key () :<!ref>
  [p : addr | null < p]
  (@[byte][16] @ p,
   @[byte][16] @ p -<lin,prf> void |
   ptr p) = "mac#%"

(* Return a pointer to a one-time-initialized key of length 64. *)
fun
halfsiphash_key () :<!ref>
  [p : addr | null < p]
  (@[byte][8] @ p,
   @[byte][8] @ p -<lin,prf> void |
   ptr p) = "mac#%"

(********************************************************************)

