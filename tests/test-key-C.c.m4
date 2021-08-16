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
#include <stdlib.h>
#include <stdint.h>
#include <string.h>
#include <siphash/key.h>
#include <siphash/siphash.h>
#include <siphash/halfsiphash.h>

static bool
check_bytes (const void *bytes1,
             const void *bytes2,
             size_t n)
{
  return (memcmp (bytes1, bytes2, n) == 0);
}

static void
print_bytes (const void *bytes, size_t n)
{
  for (size_t j = 0; j < n; j += 1)
    {
      uint8_t elem = ((const uint8_t *) bytes)[j];
      if (0 < j)
        printf (" ");
      printf ("%02X", (int) elem);
    }
}

static void
test_siphash_keys_equal (void)
{
  const void *key1 = siphash_key ();
  const void *key2 = siphash_key ();
  const void *key3 = siphash_key ();
  const void *key4 = siphash_key ();

  assert (check_bytes (key1, key2, 16));
  assert (check_bytes (key1, key3, 16));
  assert (check_bytes (key1, key4, 16));

  printf ("siphash_key ()       ");
  print_bytes (key1, 16);
  printf ("\n");
}

static void
test_halfsiphash_keys_equal (void)
{
  const void *key1 = halfsiphash_key ();
  const void *key2 = halfsiphash_key ();
  const void *key3 = halfsiphash_key ();
  const void *key4 = halfsiphash_key ();

  assert (check_bytes (key1, key2, 16));
  assert (check_bytes (key1, key3, 16));
  assert (check_bytes (key1, key4, 16));

  printf ("halfsiphash_key ()   ");
  print_bytes (key1, 8);
  printf ("\n");
}

static void
use_siphash_key (void)
{
  const char *s1 = "hash1 test";
  size_t n1 = strlen (s1);
  uint64_t hash1a;
  siphash_2_4 (s1, n1, siphash_key (), (void *) &hash1a, 8);
  uint64_t hash1b;
  siphash_2_4 (s1, n1, siphash_key (), (void *) &hash1b, 8);
  uint64_t hash1c;
  siphash_2_4 (s1, n1, siphash_key (), (void *) &hash1c, 8);
  uint64_t hash1d;
  siphash_2_4 (s1, n1, siphash_key (), (void *) &hash1d, 8);
  assert (hash1a == hash1b);
  assert (hash1a == hash1c);
  assert (hash1a == hash1d);
  printf ("siphash of \"%s\" = %llu\n", s1,
          (long long unsigned int) hash1a);

  const char *s2 = "hash2 test";
  size_t n2 = strlen (s2);
  uint64_t hash2a;
  siphash_2_4 (s2, n2, siphash_key (), (void *) &hash2a, 8);
  uint64_t hash2b;
  siphash_2_4 (s2, n2, siphash_key (), (void *) &hash2b, 8);
  uint64_t hash2c;
  siphash_2_4 (s2, n2, siphash_key (), (void *) &hash2c, 8);
  uint64_t hash2d;
  siphash_2_4 (s2, n2, siphash_key (), (void *) &hash2d, 8);
  assert (hash2a == hash2b);
  assert (hash2a == hash2c);
  assert (hash2a == hash2d);
  printf ("siphash of \"%s\" = %llu\n", s2,
          (long long unsigned int) hash2a);
}

static void
use_halfsiphash_key (void)
{
  const char *s1 = "hash1 test";
  size_t n1 = strlen (s1);
  uint32_t hash1a;
  halfsiphash_2_4 (s1, n1, halfsiphash_key (), (void *) &hash1a, 4);
  uint32_t hash1b;
  halfsiphash_2_4 (s1, n1, halfsiphash_key (), (void *) &hash1b, 4);
  uint32_t hash1c;
  halfsiphash_2_4 (s1, n1, halfsiphash_key (), (void *) &hash1c, 4);
  uint32_t hash1d;
  halfsiphash_2_4 (s1, n1, halfsiphash_key (), (void *) &hash1d, 4);
  assert (hash1a == hash1b);
  assert (hash1a == hash1c);
  assert (hash1a == hash1d);
  printf ("halfsiphash of \"%s\" = %llu\n", s1,
          (long long unsigned int) hash1a);

  const char *s2 = "hash2 test";
  size_t n2 = strlen (s2);
  uint32_t hash2a;
  halfsiphash_2_4 (s2, n2, halfsiphash_key (), (void *) &hash2a, 4);
  uint32_t hash2b;
  halfsiphash_2_4 (s2, n2, halfsiphash_key (), (void *) &hash2b, 4);
  uint32_t hash2c;
  halfsiphash_2_4 (s2, n2, halfsiphash_key (), (void *) &hash2c, 4);
  uint32_t hash2d;
  halfsiphash_2_4 (s2, n2, halfsiphash_key (), (void *) &hash2d, 4);
  assert (hash2a == hash2b);
  assert (hash2a == hash2c);
  assert (hash2a == hash2d);
  printf ("halfsiphash of \"%s\" = %llu\n", s2,
          (long long unsigned int) hash2a);
}

int
main (int argc, char *argv[])
{
  test_siphash_keys_equal ();
  test_halfsiphash_keys_equal ();
  use_siphash_key ();
  use_halfsiphash_key ();
}
