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

#ifndef ATS2_SIPHASH_CATS_KEY_CATS_HEADER_GUARD__
#define ATS2_SIPHASH_CATS_KEY_CATS_HEADER_GUARD__

#ifdef __GNUC__

#if 10 <= __GNUC__
#define ats2_siphash_attribute_const [[gnu::const]]
#else
#define ats2_siphash_attribute_const __attribute__((__const__))
#endif

#else /* !__GNUC__ */

#define ats2_siphash_attribute_const

#endif /* !__GNUC__ */

extern atstype_ptr ats2_siphash_get_key_128 (void);
extern atstype_ptr ats2_siphash_get_key_64 (void);

ats2_siphash_attribute_const ats2_siphash_inline atstype_ptr
ats2_siphash_siphash_key (void)
{
  return ats2_siphash_get_key_128 ();
}

ats2_siphash_attribute_const ats2_siphash_inline atstype_ptr
ats2_siphash_halfsiphash_key (void)
{
  return ats2_siphash_get_key_64 ();
}

#endif /* ATS2_SIPHASH_CATS_KEY_CATS_HEADER_GUARD__ */
