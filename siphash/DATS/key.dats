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

%{#
#include "config.h"
#include <unistd.h>
#include <stdio.h>
#include <stdlib.h>
%}

#define ATS_PACKNAME "ats2-siphash"
#define ATS_EXTERN_PREFIX "ats2_siphash_"

#define ATS_DYNLOADFLAG 0

#include "share/atspre_define.hats"
#include "share/atspre_staload.hats"

staload "siphash/SATS/key.sats"

staload "siphash/SATS/atomic.sats"
staload "siphash/SATS/spinlock.sats"
staload "siphash/SATS/initialize_once.sats"
staload _ = "siphash/DATS/atomic.dats"
staload _ = "siphash/DATS/spinlock.dats"
staload _ = "siphash/DATS/initialize_once.dats"

extern praxi
fake_initialization :
  {t : vt@ype}
  {n : int}
  (&(@[t?][n]) >> @[t][n]) -<prf> void

fn {t : vt@ype}
make_pf_view {p : addr} {n : int} (p : ptr p, n : size_t n) :<>
    (@[t][n] @ p, @[t][n] @ p -<lin,prf> void | ptr p) =
  let
    extern praxi {t : vt@ype}
    make_view : {p : addr} {n : int} () -<prf> @[t][n] @ p
    extern praxi {t : vt@ype}
    make_consume_view :
      {p : addr} {n : int} () -<prf>
        (@[t][n] @ p) -<lin,prf> void
  in
    (make_view<t> {p} {n} (),
     make_consume_view<t> {p} {n} () |
     p)
  end

(********************************************************************)

%{^

static void
ats2_siphash_make_key_failure (void)
{
  fputs ("make_key(KEY, KEYLEN) has failed for some reason\n",
         stderr);
  abort ();
}

static atstype_byte ats2_siphash_key_128_storage[16];
static atstype_byte ats2_siphash_key_64_storage[8];

%}

implement
siphash_make_key (key, keylen) =
  let
    val retval = $extfcall (int, "getentropy", addr@ key, keylen)
    prval _ = fake_initialization (key)
  in
    if retval <> 0 then
      $extfcall (void, "ats2_siphash_make_key_failure")
  end

(********************************************************************)

local
  var key_init = initialize_once_nil ()
  var key_storage : Ptr1?
in
  fn
  compute_key (key_storage : &ptr? >> ptr) : void =
    {
      val n = i2sz 16
      val p = $extval (Ptr0, "ats2_siphash_key_128_storage")
      val (pf_view, consume_pf_view | p) = make_pf_view<byte> (p, n)
      val _ = siphash_make_key (!p, n)
      prval _ = consume_pf_view pf_view
      val _ = key_storage := p
    }

  extern fun
  ats2_siphash_get_key_128 () : ptr = "ext#"

  implement
  ats2_siphash_get_key_128 () =
    initialize_once<ptr> (addr@ key_init,
                          addr@ key_storage,
                          compute_key)
end

(********************************************************************)

local
  var key_init = initialize_once_nil ()
  var key_storage : Ptr1?
in
  fn
  compute_key (key_storage : &ptr? >> ptr) : void =
    {
      val n = i2sz 8
      val p = $extval (Ptr0, "ats2_siphash_key_64_storage")
      val (pf_view, consume_pf_view | p) = make_pf_view<byte> (p, n)
      val _ = siphash_make_key (!p, n)
      prval _ = consume_pf_view pf_view
      val _ = key_storage := p
    }

  extern fun
  ats2_siphash_get_key_64 () : ptr = "ext#"

  implement
  ats2_siphash_get_key_64 () =
    initialize_once<ptr> (addr@ key_init,
                          addr@ key_storage,
                          compute_key)
end

(********************************************************************)
