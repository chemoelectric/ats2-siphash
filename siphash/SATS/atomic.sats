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
#include "siphash/CATS/atomic.cats"
%}

(*------------------------------------------------------------------*)

typedef atomic_int (i : int) =
  $extype"ats2_siphash_atomic_int"
typedef atomic_int =
  [i : int] atomic_int (i)

typedef atomic_int_ptr (p : addr) =
  $extype"ats2_siphash_atomic_int_ptr"
typedef atomic_int_ptr =
  [p : addr] atomic_int_ptr (p)

typedef atomic_size_t_ptr (p : addr) =
  $extype"ats2_siphash_atomic_size_t_ptr"
typedef atomic_size_t_ptr =
  [p : addr] atomic_size_t_ptr (p)

(*------------------------------------------------------------------*)
(* Type conversions. *)

castfn
int2atomic_int {i : int} (i : int i) :<> atomic_int i

castfn
atomic_int2int {i : int} (i : atomic_int i) :<> int i

castfn
bool2atomic_int {b : bool} (b : bool b) :<> atomic_int (bool2int b)

castfn
atomic_int2bool {i : int} (i : atomic_int i) :<> bool (int2bool i)

castfn
atomic_int2int {i : int} (i : atomic_int i) :<> int i

fun
atomic_int_ref2ptr (i : &atomic_int) :<!ref> atomic_int_ptr = "mac#%"

(*------------------------------------------------------------------*)
(* Fences. *)

fun
atomic_thread_fence_seq_cst () :<!ref> void = "mac#%"

(*------------------------------------------------------------------*)
(* Loading. *)

fun
atomic_load_seq_cst_size_ptr (a : atomic_size_t_ptr) :<!ref> size_t =
  "mac#ats2_siphash_atomic_load_seq_cst"

overload atomic_load_seq_cst_size with atomic_load_seq_cst_size_ptr

fun
atomic_load_acquire_int_ptr (a : atomic_int_ptr) :<!ref> int =
  "mac#ats2_siphash_atomic_load_acquire"

fun {}
atomic_load_acquire_int_ref (a : &atomic_int) :<!ref> int

overload atomic_load_acquire_int with atomic_load_acquire_int_ptr
overload atomic_load_acquire_int with atomic_load_acquire_int_ref

overload atomic_load_seq_cst with atomic_load_seq_cst_size
overload atomic_load_acquire with atomic_load_acquire_int

(*------------------------------------------------------------------*)
(* Storing. *)

fun
atomic_store_release_int_ptr (a     : atomic_int_ptr,
                              value : int) :<!refwrt> void =
  "mac#ats2_siphash_atomic_store_release"

fun {}
atomic_store_release_int_ref (a     : &atomic_int,
                              value : int) :<!refwrt> void

overload atomic_store_release_int with atomic_store_release_int_ptr
overload atomic_store_release_int with atomic_store_release_int_ref

overload atomic_store_release with atomic_store_release_int

(*------------------------------------------------------------------*)
(* Fetch and add/subtract. *)

fun
atomic_fetch_add_seq_cst_size (a : atomic_size_t_ptr,
                               n : size_t) :<!refwrt> size_t =
  "mac#ats2_siphash_atomic_fetch_add_seq_cst"

fun
atomic_fetch_sub_seq_cst_size (a : atomic_size_t_ptr,
                               n : size_t) :<!refwrt> size_t =
  "mac#ats2_siphash_atomic_fetch_sub_seq_cst"

overload atomic_fetch_add_seq_cst with atomic_fetch_add_seq_cst_size
overload atomic_fetch_sub_seq_cst with atomic_fetch_sub_seq_cst_size

(*------------------------------------------------------------------*)
