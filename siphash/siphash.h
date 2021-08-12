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

#ifndef SIPHASH_SIPHASH_HEADER_GUARD__
#define SIPHASH_SIPHASH_HEADER_GUARD__

#include <stdint.h>

/* A clone of the reference implementation’s ‘siphash()’ function,
   except that there is no return value. */
void siphash_2_4 (const void *in, const size_t inlen, const void *k,
                  uint8_t *out, const size_t outlen);

/* Similar to siphash_2_4, but for the more conservative
   implementation. */
void siphash_4_8 (const void *in, const size_t inlen, const void *k,
                  uint8_t *out, const size_t outlen);

/* This variant accepts crounds and drounds as arguments.  */
void siphash_c_d (const void *in, const size_t inlen, const void *k,
                  unsigned int crounds, unsigned int drounds,
                  uint8_t *out, const size_t outlen);

#endif /* SIPHASH_SIPHASH_HEADER_GUARD__ */
