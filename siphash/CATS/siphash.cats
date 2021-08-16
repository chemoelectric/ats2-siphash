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

#ifndef ATS2_SIPHASH_CATS_HEADER_GUARD__
#define ATS2_SIPHASH_CATS_HEADER_GUARD__

_Static_assert (sizeof (atstype_uint32) == 4,
                "uint32 is not 4 bytes");
_Static_assert (sizeof (atstype_uint64) == 8,
                "uint32 is not 8 bytes");

#define ats2_siphash_inline ATSinline()

#ifdef __GNUC__

#if 10 <= __GNUC__
#define ats2_siphash_always_inline              \
  [[gnu::always_inline]] ats2_siphash_inline
#else
#define ats2_siphash_always_inline                          \
  __attribute__((__always_inline__)) ats2_siphash_inline
#endif

#define ats2_siphash_memcpy __builtin_memcpy
#define ats2_siphash_bswap32 __builtin_bswap32
#define ats2_siphash_bswap64 __builtin_bswap64

#if __BYTE_ORDER__ == __ORDER_LITTLE_ENDIAN__
#define ATS2_SIPHASH_BIG_ENDIAN 0
#elif __BYTE_ORDER__ == __ORDER_BIG_ENDIAN__
#define ATS2_SIPHASH_BIG_ENDIAN 1
#else
#error The platform must be little endian or big endian.
#endif

#else /* not __GNUC__ */

#include <string.h>
#include <stdint.h>

#define ats2_siphash_always_inline ats2_siphash_inline

#define ats2_siphash_memcpy memcpy
#define ats2_siphash_bswap32(x)                 \
  ((((x) & UINT32_C(0x000000FF)) << 24) |       \
   (((x) & UINT32_C(0x0000FF00)) << 8) |        \
   (((x) & UINT32_C(0x00FF0000)) >> 8) |        \
   (((x) & UINT32_C(0xFF000000)) >> 24))
#define ats2_siphash_bswap64(x)                     \
  ((((x) & UINT64_C(0x00000000000000FF)) << 56) |   \
   (((x) & UINT64_C(0x000000000000FF00)) << 40) |   \
   (((x) & UINT64_C(0x0000000000FF0000)) << 24) |   \
   (((x) & UINT64_C(0x00000000FF000000)) << 8) |    \
   (((x) & UINT64_C(0x000000FF00000000)) >> 8) |    \
   (((x) & UINT64_C(0x0000FF0000000000)) >> 24) |   \
   (((x) & UINT64_C(0x00FF000000000000)) >> 40) |   \
   (((x) & UINT64_C(0xFF00000000000000)) >> 56))

#ifndef ATS2_SIPHASH_BIG_ENDIAN
#error Please set ATS2_SIPHASH_BIG_ENDIAN to 0 or 1 in CFLAGS.
#endif

#endif

_Static_assert (ats2_siphash_bswap32 (0xDEADBEEFU) == 0xEFBEADDEU,
                "ats2_siphash_bswap32 does not work correctly.");
/* FIXME: Add a test of ats2_siphash_bswap64 */

/* A natural numbers mod function. */
ats2_siphash_always_inline atstype_size
ats2_siphash_natmod_size (atstype_size x, atstype_size y)
{
  return (x % y);
}

/* Bitwise inclusive or. */
ats2_siphash_always_inline atstype_uint32
ats2_siphash_bitwise_ior_uint32 (atstype_uint32 x,
                                 atstype_uint32 y)
{
  return (x | y);
}

/* Bitwise inclusive or. */
ats2_siphash_always_inline atstype_uint64
ats2_siphash_bitwise_ior_uint64 (atstype_uint64 x,
                                 atstype_uint64 y)
{
  return (x | y);
}

/* Bitwise exclusive or. */
ats2_siphash_always_inline atstype_uint32
ats2_siphash_bitwise_xor_uint32 (atstype_uint32 x,
                                 atstype_uint32 y)
{
  return (x ^ y);
}

/* Bitwise exclusive or. */
ats2_siphash_always_inline atstype_uint64
ats2_siphash_bitwise_xor_uint64 (atstype_uint64 x,
                                 atstype_uint64 y)
{
  return (x ^ y);
}

/* Bitwise left shift, with zero-fill. */
ats2_siphash_always_inline atstype_uint32
ats2_siphash_bitwise_lshift_uint32_uint (atstype_uint32 x,
                                         atstype_uint i)
{
  return (x << i);
}

/* Bitwise left shift, with zero-fill. */
ats2_siphash_always_inline atstype_uint64
ats2_siphash_bitwise_lshift_uint64_uint (atstype_uint64 x,
                                         atstype_uint i)
{
  return (x << i);
}

/* Bitwise right shift, with zero-fill. */
ats2_siphash_always_inline atstype_uint32
ats2_siphash_bitwise_rshift_uint32_uint (atstype_uint32 x,
                                         atstype_uint i)
{
  return (x >> i);
}

/* Bitwise right shift, with zero-fill. */
ats2_siphash_always_inline atstype_uint64
ats2_siphash_bitwise_rshift_uint64_uint (atstype_uint64 x,
                                         atstype_uint i)
{
  return (x >> i);
}

/* Bitwise left rotation by an amount less than 32. */
ats2_siphash_always_inline atstype_uint32
ats2_siphash_bitwise_lrotate_uint32_uint (atstype_uint32 x,
                                          atstype_uint i)
{
  return (x << i) | (x >> ((-i) & 31));
}

/* Bitwise left rotation by an amount less than 64. */
ats2_siphash_always_inline atstype_uint64
ats2_siphash_bitwise_lrotate_uint64_uint (atstype_uint64 x,
                                          atstype_uint i)
{
  return (x << i) | (x >> ((-i) & 63));
}

/* On big endian platforms, swap the byte order. On little endian
   platforms, do not change the value. */
ats2_siphash_always_inline atstype_uint32
ats2_siphash_fix_byte_order_uint32 (atstype_uint32 x)
{
#if ATS2_SIPHASH_BIG_ENDIAN
  return ats2_siphash_bswap32 (x);
#else
  return x;
#endif
}

ats2_siphash_always_inline atstype_uint64
ats2_siphash_fix_byte_order_uint64 (atstype_uint64 x)
{
#if ATS2_SIPHASH_BIG_ENDIAN
  return ats2_siphash_bswap64 (x);
#else
  return x;
#endif
}

/* Get a little endian atstype_uint32 from memory, where perhaps the
   data is misaligned. */
ats2_siphash_always_inline atstype_uint32
ats2_siphash_get32bits (const atstype_ptr p)
{
  atstype_uint32 v;
  ats2_siphash_memcpy (&v, p, 4);
  return ats2_siphash_fix_byte_order_uint32 (v);
}

/* Get a little endian atstype_uint64 from memory, where perhaps the
   data is misaligned. */
ats2_siphash_always_inline atstype_uint64
ats2_siphash_get64bits (const atstype_ptr p)
{
  atstype_uint64 v;
  ats2_siphash_memcpy (&v, p, 8);
  return ats2_siphash_fix_byte_order_uint64 (v);
}

/* Put a little endian atstype_uint32 to memory, where perhaps the
   data is misaligned. */
ats2_siphash_always_inline void
ats2_siphash_put32bits (atstype_ptr p, atstype_uint32 v)
{
  v = ats2_siphash_fix_byte_order_uint32 (v);
  ats2_siphash_memcpy (p, &v, 4);
}

/* Put a little endian atstype_uint64 to memory, where perhaps the
   data is misaligned. */
ats2_siphash_always_inline void
ats2_siphash_put64bits (atstype_ptr p, atstype_uint64 v)
{
  v = ats2_siphash_fix_byte_order_uint64 (v);
  ats2_siphash_memcpy (p, &v, 8);
}

#endif /* ATS2_SIPHASH_CATS_HEADER_GUARD__ */
