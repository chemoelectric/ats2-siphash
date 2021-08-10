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
#include "siphash/CATS/siphash.cats"
%}

#define ATS_PACKNAME "ats2-siphash"
#define ATS_EXTERN_PREFIX "ats2_siphash_"

#define ATS_DYNLOADFLAG 0

#include "share/atspre_define.hats"
#include "share/atspre_staload.hats"

(********************************************************************)

extern castfn
b2u8 : byte -<> uint8

extern castfn
u2u64 : uint -<> uint64

(********************************************************************)

(* A natural numbers mod function. *)
extern fn
natmod_size {x, y : nat | y != 0}
            (x    : size_t x,
             y    : size_t y) :<>
    [z : nat | z <= x; z < y] size_t z = "mac#%"

overload natmod with natmod_size

(* Bitwise exclusive or. *)
extern fn
bitwise_xor_uint64 (x : uint64,
                    y : uint64) :<> uint64 = "mac#%"

overload bitwise_xor with bitwise_xor_uint64

(* Bitwise left shift, with zero-fill. *)
extern fn
bitwise_lshift_uint64_uint (x : uint64,
                            i : uint) :<> uint64 = "mac#%"

overload bitwise_lshift with bitwise_lshift_uint64_uint

(* Bitwise right shift, with zero-fill. *)
extern fn
bitwise_rshift_uint64_uint (x : uint64,
                            i : uint) :<> uint64 = "mac#%"

overload bitwise_rshift with bitwise_rshift_uint64_uint

(* Bitwise left rotation. *)
extern fn
bitwise_lrotate_uint64_uint {i : int | i < 64}
                            (x : uint64,
                             i : uint i) :<> uint64 = "mac#%"

overload bitwise_lrotate with bitwise_lrotate_uint64_uint

(* Get the uint64 at p, where the value possibly is misaligned. *)
extern fn
get64bits {p  : addr}
          (pf : !(@[byte][8] @ p) >> _ |
           p  : ptr p) :<!ref> uint64 = "mac#%"

(* Put a uint64 to p, where the value possibly is misaligned. *)
extern fn
put64bits {p  : addr}
          (pf : !(@[byte?][8] @ p) >> @[byte][8] @ p |
           p  : ptr p,
           v  : uint64) :<!refwrt> void = "mac#%"

(* On big endian platforms, swap the byte order. On little endian
   systems, do not change the value. *)
extern fn
fix_byte_order_uint64 (x : uint64) :<> uint64 = "mac#%"

overload fix_byte_order with fix_byte_order_uint64

(********************************************************************)
