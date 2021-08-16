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

#ifndef ATS2_SIPHASH_CATS_SPINLOCK_CATS_HEADER_GUARD__
#define ATS2_SIPHASH_CATS_SPINLOCK_CATS_HEADER_GUARD__

#include <stdatomic.h>
#include "siphash/CATS/atomic.cats"

/********************************************************************/

#ifdef __GNUC__

/*
 * FIXME: Similar things can be done for other platforms and other
 *        compilers.
 */
#if defined(__i386__) || defined(__x86_64__)
#define ats2_siphash_pause() __builtin_ia32_pause ()
#endif

#else

#define ats2_siphash_pause() do { /* nothing */ } while (0)

#endif

/********************************************************************/

typedef struct
{
  /* Use unsigned integers, so they will wrap around when they
     overflow. */
  ats2_siphash_atomic_size_t active;
  ats2_siphash_atomic_size_t available;
} ats2_siphash_spinlock_struct_t;

typedef ats2_siphash_spinlock_struct_t *ats2_siphash_spinlock_t;

ats2_siphash_inline ats2_siphash_spinlock_t
ats2_siphash_spinlock_alloc (void)
{
  ats2_siphash_spinlock_t lock =
    ATS_MALLOC (sizeof (ats2_siphash_spinlock_struct_t));
  lock->active = 0;
  lock->available = 0;
  return lock;
}

ats2_siphash_inline void
ats2_siphash_spinlock_free (ats2_siphash_spinlock_t lock)
{
  ATS_MFREE (lock);
}

ats2_siphash_inline ats2_siphash_spinlock_struct_t
ats2_siphash_spinlock_data (void)
{
  ats2_siphash_spinlock_struct_t lock;
  lock.active = 0;
  lock.available = 0;
  return lock;
}

ats2_siphash_inline ats2_siphash_atomic_size_t_ptr
ats2_siphash_spinlock_active_p (ats2_siphash_spinlock_t lock)
{
  return &(lock->active);
}

ats2_siphash_inline ats2_siphash_atomic_size_t_ptr
ats2_siphash_spinlock_available_p (ats2_siphash_spinlock_t lock)
{
  return &(lock->available);
}

/********************************************************************/

#endif /* ATS2_SIPHASH_CATS_SPINLOCK_CATS_HEADER_GUARD__ */
