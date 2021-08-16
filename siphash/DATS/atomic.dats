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
#include "siphash/CATS/atomic.cats"
%}

#define ATS_PACKNAME "ats2-siphash"
#define ATS_EXTERN_PREFIX "ats2_siphash_"

#define ATS_DYNLOADFLAG 0

#include "share/atspre_define.hats"
#include "share/atspre_staload.hats"

staload "siphash/SATS/atomic.sats"

implement {}
atomic_load_acquire_int_ref (a) =
  let
    val p = atomic_int_ref2ptr a
  in
    atomic_load_acquire_int_ptr p
  end

implement {}
atomic_store_release_int_ref (a, value) =
  let
    val p = atomic_int_ref2ptr a
  in
    atomic_store_release_int_ptr (p, value)
  end
