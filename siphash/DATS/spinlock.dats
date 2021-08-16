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
#include "siphash/CATS/spinlock.cats"
%}

#define ATS_PACKNAME "ats2-siphash"
#define ATS_EXTERN_PREFIX "ats2_siphash_"

#define ATS_DYNLOADFLAG 0

#include "share/atspre_define.hats"
#include "share/atspre_staload.hats"

staload "siphash/SATS/atomic.sats"
staload _ = "siphash/DATS/atomic.dats"

staload "siphash/SATS/spinlock.sats"

extern praxi
make_spinlocked_v {p : addr} () :<prf>
    spinlocked_v p

extern praxi
consume_spinlocked_v {p : addr} (pf : spinlocked_v p) :<prf>
    void

extern fun
spinlock_active_p {p : addr} (lock : !spinlock_t p) :<!ref>
    atomic_size_t_ptr = "mac#%"

extern fun
spinlock_available_p {p : addr} (lock : !spinlock_t p) :<!ref>
    atomic_size_t_ptr = "mac#%"

extern fun
pause () :<> void = "mac#%"

implement {}
spinlock_data2spinlock (data) =
  $UNSAFE.cast (addr@ data)

implement {}
spinlock_obtain_lock {p} (lock) =
  let
    val active_p = spinlock_active_p (lock)
    val available_p = spinlock_available_p (lock)

    val my_ticket =
      atomic_fetch_add_seq_cst (available_p, i2sz 1)

    fun {}
    wait_my_turn () : void =
      let
        val active_ticket = atomic_load_seq_cst (active_p)
      in
        if my_ticket <> active_ticket then
          begin
            pause ();
            wait_my_turn ()
          end
      end

    val _ = $effmask_all (wait_my_turn ())
    val _ = atomic_thread_fence_seq_cst ()
  in
    (make_spinlocked_v {p} () | )
  end

implement {}
spinlock_release_lock {p} (pf | lock) =
  {
    val active_p = spinlock_active_p (lock)
    val _ = atomic_thread_fence_seq_cst ()
    val _ = atomic_fetch_add_seq_cst (active_p, i2sz 1)
    prval _ = consume_spinlocked_v pf
  }
