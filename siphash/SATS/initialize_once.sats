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

staload "siphash/SATS/atomic.sats"
staload "siphash/SATS/spinlock.sats"

(*------------------------------------------------------------------*)

typedef initialize_once_t =
  @{
    initialize_once_initialized = atomic_int,
    initialize_once_lock_data = spinlock_data_t
  }

fn
initialize_once_nil () :<> initialize_once_t

fn {t : t@ype}
initialize_once (init_once_p   : ptr,
                 storage_p     : ptr,
                 compute_value : (&t? >> t) -> void) : t

(*------------------------------------------------------------------*)
