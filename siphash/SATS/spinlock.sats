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
#include "siphash/CATS/spinlock.cats"
%}

staload "siphash/SATS/atomic.sats"

(********************************************************************)
(* Fair spinlocks using a ticket system. *)
(* See https://nahratzah.wordpress.com/2012/10/12/a-trivial-fair-spinlock/ *)
(* Also see https://en.wikipedia.org/w/index.php?title=Ticket_lock&oldid=990949901 *)

typedef spinlock_data_t =
  $extype_struct"ats2_siphash_spinlock_struct_t" of
    (* The ATS compiler needs to know the size of the structure. *)
    { spinlock_ticket_next_active = size_t,
      spinlock_ticket_next_available = size_t }

abstype spinlock_t (p : addr) =
  $extype"ats2_siphash_spinlock_t"

absview spinlocked_v (p : addr)

(*------------------------------------------------------------------*)
(* Allocation of a spinlock object on the heap. *)

fun
spinlock_alloc () :<!wrt>
  [p : agz]
  (mfree_gc_v (p) | spinlock_t p) = "mac#%"

fun
spinlock_free {p : addr}
              (pf   : mfree_gc_v p |
               lock : spinlock_t p) :<!wrt>
    void = "mac#%"

overload free with spinlock_free

(*------------------------------------------------------------------*)
(* Allocation of a spinlock object on the stack or as a global. *)

(* Initialize a var with the following. *)
fun
spinlock_data () :<> spinlock_data_t = "mac#%"

(* Convert a spinlock data var to a spinlock object. *)
fun {}
spinlock_data2spinlock (data : &spinlock_data_t) :<!ref>
    [p : addr] spinlock_t p

overload spinlock with spinlock_data2spinlock

(*------------------------------------------------------------------*)
(* Using spinlock objects. *)

fun {}
spinlock_obtain_lock {p : addr}
                     (lock : spinlock_t p) :<!refwrt>
    (spinlocked_v (p) | )

fun {}
spinlock_release_lock {p : addr}
                      (pf   : spinlocked_v (p) |
                       lock : spinlock_t p) :<!refwrt>
    void

overload obtain_lock with spinlock_obtain_lock
overload release_lock with spinlock_release_lock

(********************************************************************)
