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

#define ATS_DYNLOADFLAG 0

#include "share/atspre_define.hats"
#include "share/atspre_staload.hats"

staload KEY = "siphash/SATS/key.sats"

fn {}
make_bytes_view {n : int} {p : addr} (p : ptr p) :<>
    (@[byte][n] @ p, @[byte][n] @ p -<lin,prf> void | ptr p) =
  let
    extern praxi
    make_view :
      () -<prf> (@[byte][n] @ p, @[byte][n] @ p -<lin,prf> void)
    prval (pf, consume_pf) = make_view ()
  in
    (pf, consume_pf | p)
  end

extern fn
siphash_make_key {p      : addr}
                 {keylen : int}
                 (key    : ptr p,
                  keylen : size_t keylen) : void = "ext#"

implement
siphash_make_key {p} {keylen} (key, keylen) =
  {
    val _ = assertloc (keylen <= i2sz 256)
    val (pf, consume_pf | key) = make_bytes_view {keylen} {p} (key)
    val _ = $KEY.siphash_make_key (!key, keylen)
    prval _ = consume_pf pf
  }

%{$

/*
 * Export symbols for the inline functions
 * siphash_key() and halfsiphash_key().
 */

#include <siphash/key.h>

#define _attr_const__ siphash_key_attribute_const__

_attr_const__ extern inline const void *siphash_key (void);
_attr_const__ extern inline const void *halfsiphash_key (void);

%}
