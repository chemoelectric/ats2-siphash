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

#define ATS_DYNLOADFLAG 0

staload "siphash/SATS/atomic.sats"
staload _ = "siphash/DATS/atomic.dats"

staload "siphash/SATS/spinlock.sats"
staload _ = "siphash/DATS/spinlock.dats"

staload "siphash/SATS/initialize_once.sats"

(********************************************************************)

implement
initialize_once_nil () =
  @{
    initialize_once_initialized = bool2atomic_int false,
    initialize_once_lock_data = spinlock_data ()
  }

implement {t}
initialize_once (init_once_p, storage_p, compute_value) =
  let
    fn {t : t@ype}
    to_viewtype {p : addr} (p : ptr p) :<>
        [q : addr | q == p]
        (t @ q | ptr q) =
      let
        extern praxi
        make_view () :<prf> t @ p
      in
        (make_view () | p)
      end

    extern praxi
    consume_view {t : t@ype} {p : addr} (pf : t @ p) :<prf>
        void

    fn
    get_lock (init_once : &initialize_once_t) :
        [p : addr] (spinlocked_v p | spinlock_t p) =
      let
        macdef lock_data = init_once.initialize_once_lock_data
        val lock = spinlock (lock_data)
        val (pf_locked | ) = obtain_lock (lock)
      in
        (pf_locked | lock)
      end

    fn {}
    is_initialized (init_once : &initialize_once_t) : bool =
      let
        macdef initialized = init_once.initialize_once_initialized
      in
        int2bool (atomic_load_acquire (initialized))
      end

    fn
    mark_initialized (init_once : &initialize_once_t) : void =
      let
        macdef initialized = init_once.initialize_once_initialized
      in
        atomic_store_release (initialized, bool2int true)
      end

    extern praxi {t : t@ype}
    assume_initialized {p : addr} (pf : !(t? @ p) >> t @ p) :<prf>
        void

    val [init_once_p : addr] (pf_init_once | init_once_p) =
      to_viewtype<initialize_once_t> (g1ofg0 init_once_p)

    val [storage_p : addr] (pf_storage | storage_p) =
      to_viewtype<t?> (g1ofg0 storage_p)
  in
    if is_initialized (!init_once_p) then
      let
        prval _ = assume_initialized (pf_storage)
        val value = !storage_p
        prval _ = consume_view pf_init_once
        prval _ = consume_view pf_storage
      in
        value
      end
    else
      let
        val (pf_locked | lock) = get_lock (!init_once_p)
      in
        if is_initialized (!init_once_p) then
          let
            val _ = release_lock (pf_locked | lock)
            prval _ = assume_initialized (pf_storage)
            val value = !storage_p
            prval _ = consume_view pf_init_once
            prval _ = consume_view pf_storage
          in
            value
          end
        else
          let
            val _ = compute_value (!storage_p)
            val _ = mark_initialized (!init_once_p)
            val _ = release_lock (pf_locked | lock)
            val value = !storage_p
            prval _ = consume_view pf_init_once
            prval _ = consume_view pf_storage
          in
            value
          end
      end
  end

(********************************************************************)
