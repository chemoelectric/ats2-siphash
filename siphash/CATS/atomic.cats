/*

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

*/

#ifndef ATS2_SIPHASH_CATS_ATOMIC_CATS_HEADER_GUARD__
#define ATS2_SIPHASH_CATS_ATOMIC_CATS_HEADER_GUARD__

#include <stdatomic.h>
#include "siphash/CATS/siphash.cats"

/********************************************************************/

typedef atomic_int ats2_siphash_atomic_int;
typedef volatile atomic_int *ats2_siphash_atomic_int_ptr;

typedef atomic_size_t ats2_siphash_atomic_size_t;
typedef volatile atomic_size_t *ats2_siphash_atomic_size_t_ptr;

ats2_siphash_inline ats2_siphash_atomic_int_ptr
ats2_siphash_atomic_int_ref2ptr (atstype_ref p)
{
  return (ats2_siphash_atomic_int_ptr) (void *) p;
}

#define ats2_siphash_atomic_thread_fence_seq_cst() \
  atomic_thread_fence (memory_order_seq_cst)

#define ats2_siphash_atomic_load_seq_cst(p) \
  atomic_load_explicit ((p), memory_order_seq_cst)

#define ats2_siphash_atomic_load_acquire(p) \
  atomic_load_explicit ((p), memory_order_acquire)

#define ats2_siphash_atomic_store_release(p, value) \
  atomic_store_explicit((p), (value), memory_order_release)

#define ats2_siphash_atomic_fetch_add_seq_cst(p, n) \
  atomic_fetch_add_explicit ((p), (n), memory_order_seq_cst)

#define ats2_siphash_atomic_fetch_sub_seq_cst(p, n) \
  atomic_fetch_sub_explicit ((p), (n), memory_order_seq_cst)

/********************************************************************/

#endif /* ATS2_SIPHASH_CATS_ATOMIC_CATS_HEADER_GUARD__ */
