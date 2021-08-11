(*

Copyright © 2018, 2021 Barry Schwartz

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

staload "siphash/SATS/array_prf.sats"

primplement
array_v_subdivide2 {t} {p} {n1, n2} pf =
  array_v_split {t} {p} {n1 + n2} {n1} pf

primplement
array_v_subdivide3 {t} {p} {n1, n2, n3} pf =
  let
    prval (pf1, pf23) =
      array_v_split {t} {p} {n1 + n2 + n3} {n1} pf
    prval (pf2, pf3) =
      array_v_split {t} {p + n1 * sizeof t} {n2 + n3} {n2} pf23
  in
    @(pf1, pf2, pf3)
  end

primplement
array_v_join2 {t} {p} {n1, n2} (pf1, pf2) =
  array_v_unsplit {t} {p} {n1, n2} (pf1, pf2)

primplement
array_v_join3 {t} {p} {n1, n2, n3} (pf1, pf2, pf3) =
  let
    prval pf23 =
      array_v_unsplit {t} {p + n1 * sizeof t} {n2, n3} (pf2, pf3)
    prval pf = array_v_unsplit {t} {p} {n1, n2 + n3} (pf1, pf23)
  in
    pf
  end
