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

#ifndef SIPHASH_KEY_HEADER_GUARD__
#define SIPHASH_KEY_HEADER_GUARD__

#ifdef __GNUC__

#if 10 <= __GNUC__
#define siphash_key_attribute_const__ [[gnu::const]]
#else
#define siphash_key_attribute_const__ __attribute__((__const__))
#endif

#else /* !__GNUC__ */

#define siphash_key_attribute_const__

#endif /* !__GNUC__ */

/* Return a pointer to a one-time-initialized SipHash key. */
siphash_key_attribute_const__ static inline const void *
siphash_key (void)
{
  extern const void *ats2_siphash_get_key_128 (void);
  return ats2_siphash_get_key_128 ();
}

/* Return a pointer to a one-time-initialized HalfSipHash key. */
siphash_key_attribute_const__ static inline const void *
halfsiphash_key (void)
{
  extern const void *ats2_siphash_get_key_64 (void);
  return ats2_siphash_get_key_64 ();
}

#endif /* SIPHASH_KEY_HEADER_GUARD__ */
