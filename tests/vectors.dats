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

staload "tests/vectors.sats"

%{^

#include "tests/vectors.h"

static void *
vectors_sip64_p (void)
{
  return (void *) vectors_sip64;
}

static void *
vectors_sip128_p (void)
{
  return (void *) vectors_sip128;
}

static void *
vectors_hsip32_p (void)
{
  return (void *) vectors_hsip32;
}

static void *
vectors_hsip64_p (void)
{
  return (void *) vectors_hsip64;
}

%}

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

implement
vectors_sip64 () =
  make_bytes_view {512} ($extfcall (Ptr, "vectors_sip64_p"))

implement
vectors_sip128 () =
  make_bytes_view {1024} ($extfcall (Ptr, "vectors_sip128_p"))

implement
vectors_hsip32 () =
  make_bytes_view {256} ($extfcall (Ptr, "vectors_hsip32_p"))

implement
vectors_hsip64 () =
  make_bytes_view {512} ($extfcall (Ptr, "vectors_hsip64_p"))



(*
implement
main0()=
{
  val (pf, consume_pf | p) = vectors_sip64 ()
  val _ = println! ($UNSAFE.cast{int} ($UNSAFE.ptr0_get_at<byte> (p, 0)))
  val _ = println! ($UNSAFE.cast{int} ($UNSAFE.ptr0_get_at<byte> (p, 7)))
  prval _ = consume_pf pf
}
*)
