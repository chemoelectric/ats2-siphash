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

include(`common-macros.m4')

#include <assert.h>
#include <stdbool.h>
#include <stdio.h>
#include <stdint.h>
#include <string.h>
#include <siphash/siphash.h>
#include "tests/vectors.h"

static bool
check_bytes (const void *bytes1,
             const void *bytes2,
             size_t n)
{
  return (memcmp (bytes1, bytes2, n) == 0);
}

static void
initialize_bytes (void *bytes, size_t n)
{
  for (size_t j = 0; j < n; j += 1)
    ((uint8_t *) bytes)[j] = (uint8_t) j;
}

static void
print_bytes (const void *bytes, size_t n)
{
  for (size_t j = 0; j < n; j += 1)
    {
      uint8_t elem = ((const uint8_t *) bytes)[j];
      if (0 < j)
        printf (" ");
      printf ("%02x", (int) elem);
    }
}

m4_define(`implement_test_64',`
static void
$1 (void)
{
  for (size_t i = 0; i < 64; i += 1)
    {
      uint8_t key[16];
      initialize_bytes (key, 16);

      uint8_t input[64];
      initialize_bytes (input, 64);

      uint8_t output[16];
      do { $2 } while (0);

      const uint8_t *vec = vectors_sip128[i];

      printf ("$1/%02zu: [", i);
      print_bytes (output, 16);
      printf ("]\n");

      assert (check_bytes (vec, output, 16));
    }
  printf ("\n$1 passed\n\n");
}')

implement_test_64(`test_siphash_2_4____128',`
  siphash_2_4 (input, i, key, output, 16);')

implement_test_64(`test_siphash_c_d____2_4_128',`
  siphash_c_d (input, i, key, 2, 4, output, 16);')

int
main (int argc, char *argv[])
{
  test_siphash_2_4____128 ();
  test_siphash_c_d____2_4_128 ();
}
