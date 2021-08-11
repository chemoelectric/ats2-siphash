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

(* An array is as long as its run of elements. *)
praxi
lemma_sizeof_array {t : vt@ype} {n : int} () :<prf>
    [sizeof (@[t][n]) == n * sizeof (t)] void

(* Subdivide an array view into two views. *)
prfun
array_v_subdivide2 {t : vt@ype} {p : addr} {n1, n2 : nat}
                   (pf : @[t][n1 + n2] @ p) :<prf>
    @(@[t][n1] @ p,
      @[t][n2] @ (p + n1 * sizeof t))

(* Subdivide an array view into three views. *)
prfun
array_v_subdivide3 {t : vt@ype} {p : addr} {n1, n2, n3 : nat}
                   (pf : @[t][n1 + n2 + n3] @ p) :<prf>
    @(@[t][n1] @ p,
      @[t][n2] @ (p + n1 * sizeof t),
      @[t][n3] @ (p + (n1 + n2) * sizeof t))

(* Join two contiguous array views into one view. *)
prfun
array_v_join2 {t : vt@ype} {p : addr} {n1, n2 : nat}
              (pf1 : @[t][n1] @ p,
               pf2 : @[t][n2] @ (p + n1 * sizeof t)) :<prf>
    @[t][n1 + n2] @ p

(* Join three contiguous array views into one view. *)
prfun
array_v_join3 {t : vt@ype} {p : addr} {n1, n2, n3 : nat}
              (pf1 : @[t][n1] @ p,
               pf2 : @[t][n2] @ (p + n1 * sizeof t),
               pf3 : @[t][n3] @ (p + (n1 + n2) * sizeof t)) :<prf>
    @[t][n1 + n2 + n3] @ p
