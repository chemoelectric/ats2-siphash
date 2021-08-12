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

#include "share/atspre_define.hats"
#include "share/atspre_staload.hats"

fun
vectors_sip64 () :
    [p : addr] (@[byte][512] @ p,
                @[byte][512] @ p -<lin,prf> void |
                ptr p)

fun
vectors_sip128 () :
    [p : addr] (@[byte][1024] @ p,
                @[byte][1024] @ p -<lin,prf> void |
                ptr p)

fun
vectors_hsip32 () :
    [p : addr] (@[byte][256] @ p,
                @[byte][256] @ p -<lin,prf> void |
                ptr p)

fun
vectors_hsip64 () :
    [p : addr] (@[byte][512] @ p,
                @[byte][512] @ p -<lin,prf> void |
                ptr p)
