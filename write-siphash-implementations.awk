#!/bin/awk -f
#
# Copyright © 2021 Barry Schwartz
#
# This program is free software: you can redistribute it and/or
# modify it under the terms of the GNU General Public License, as
# published by the Free Software Foundation, either version 3 of the
# License, or (at your option) any later version.
#
# This program is distributed in the hope that it will be useful, but
# WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
# General Public License for more details.
#
# You should have received copies of the GNU General Public License
# along with this program. If not, see
# <https://www.gnu.org/licenses/>.

BEGIN {
  rounds_pairs[10] = "2 4"
  rounds_pairs[20] = "4 8"
  rounds_pairs[99] = "c d"
  rounds_pairs[100] = "end"

  write_sats_include_file(rounds_pairs)
  write_dats_files(rounds_pairs)
}

function write_sats_include_file(rounds_pairs,  i, f)
{
  system("mkdir -p siphash/SATS/include")
  f = "siphash/SATS/include/siphash-implementations.inc"
  write_sats_include_header(f)
  for (i = 1; rounds_pairs[i] != "end"; i += 1)
    if (rounds_pairs[i])
      {
        print > f
        write_sats_include(f, rounds_pairs[i])
      }
}

function write_sats_include(f, rounds_pair,  round)
{
  split(rounds_pair, rounds)
  if (rounds[1] == "c")
    write_sats_include_c_d(f)
  else
    write_sats_include_m_n(f, rounds[1], rounds[2])
}

function write_sats_include_m_n(f, crounds, drounds)
{
  write_sats_include_m_n_outlen(f, 8, crounds, drounds)
  print > f
  write_sats_include_m_n_outlen(f, 16, crounds, drounds)
  print > f
  write_sats_include_m_n_output(f, crounds, drounds)
}

function write_sats_include_c_d(f)
{
  write_sats_include_c_d_outlen(f, 8)
  print > f
  write_sats_include_c_d_outlen(f, 16)
  print > f
  write_sats_include_c_d_output(f)
}

function write_sats_include_m_n_outlen(f, outlen, crounds, drounds)
{
  print "fun" > f
  print "siphash_" crounds "_" drounds "_" (8 * outlen) > f
  print "        {inlen : int}" > f
  print "        (input : &RD(@[byte][inlen])," > f
  print "         inlen : size_t inlen," > f
  print "         key   : &RD(@[byte][16])) :<!ref> "       \
    ((outlen == 8) ? "uint64" : "@(uint64, uint64)") > f
  if (outlen == 8)
    {
      print > f
      print "overload siphash_" crounds "_" drounds                 \
        " with siphash_" crounds "_" drounds "_" (8 * outlen) > f
    }
}

function write_sats_include_m_n_output(f, crounds, drounds)
{
  print "fun" > f
  print "siphash_" crounds "_" drounds "_output" > f
  print "        {inlen  : int}" > f
  print "        {outlen : int | outlen == 8 || outlen == 16}" > f
  print "        (input  : &RD(@[byte][inlen])," > f
  print "         inlen  : size_t inlen," > f
  print "         key    : &RD(@[byte][16])," > f
  print "         output : &(@[byte?][outlen]) >> @[byte][outlen]," > f
  print "         outlen : size_t outlen) :<!refwrt> void" > f
  print > f
  print "overload siphash_" crounds "_" drounds         \
    " with siphash_" crounds "_" drounds "_output" > f
}

function write_sats_include_c_d_outlen(f, outlen)
{
  print "fun" > f
  print "siphash_c_d_" (8 * outlen) > f
  print "        {inlen   : int}" > f
  print "        (input   : &RD(@[byte][inlen])," > f
  print "         inlen   : size_t inlen," > f
  print "         key     : &RD(@[byte][16])," > f
  print "         crounds : [i : pos] uint i," > f
  print "         drounds : [i : pos] uint i) :<!ref> "     \
    ((outlen == 8) ? "uint64" : "@(uint64, uint64)") > f
  if (outlen == 8)
    {
      print > f
      print "overload siphash_c_d with siphash_c_d_" (8 * outlen) > f
    }
}

function write_sats_include_c_d_output(f)
{
  print "fun" > f
  print "siphash_c_d_output" > f
  print "        {inlen   : int}" > f
  print "        {outlen  : int | outlen == 8 || outlen == 16}" > f
  print "        (input   : &RD(@[byte][inlen])," > f
  print "         inlen   : size_t inlen," > f
  print "         key     : &RD(@[byte][16])," > f
  print "         crounds : [i : pos] uint i," > f
  print "         drounds : [i : pos] uint i," > f
  print "         output  : &(@[byte?][outlen]) >> @[byte][outlen]," > f
  print "         outlen  : size_t outlen) :<!refwrt> void" > f
  print > f
  print "overload siphash_c_d with siphash_c_d_output" > f
}

function write_sats_include_header(f)
{
  write_generated(f)
}

function write_dats_files(rounds_pairs,  i)
{
  for (i = 1; rounds_pairs[i] != "end"; i += 1)
    if (rounds_pairs[i])
      write_dats(rounds_pairs[i])
}

function write_dats(rounds_pair,  rounds)
{
  split(rounds_pair, rounds)
  if (rounds[1] == "c")
    write_dats_c_d()
  else
    write_dats_m_n(rounds[1], rounds[2])
}

function write_dats_m_n(crounds, drounds)
{
  write_dats_m_n_outlen(8, crounds, drounds)
  write_dats_m_n_outlen(16, crounds, drounds)
  write_dats_m_n_output(crounds, drounds)
}

function write_dats_c_d()
{
  write_dats_c_d_outlen(8)
  write_dats_c_d_outlen(16)
  write_dats_c_d_output()
}

function write_dats_m_n_outlen(outlen, crounds, drounds,  f)
{
  system("mkdir -p siphash/DATS")
  f = "siphash/DATS/siphash_" crounds "_" drounds "_" (8 * outlen) ".dats"
  write_dats_header(f)
  print > f
  print "local" > f
  print "  implement siphash$crounds<> () = " crounds "U" > f
  print "  implement siphash$drounds<> () = " drounds "U" > f
  print "in" > f
  print "  implement" > f
  print "  siphash_" crounds "_" drounds "_" (8 * outlen) " (input, inlen, key) =" > f
  print "    siphash_" (8 * outlen) "<> (input, inlen, key)" > f
  print "end" > f
}

function write_dats_c_d_outlen(outlen,  f)
{
  system("mkdir -p siphash/DATS")
  f = "siphash/DATS/siphash_c_d_" (8 * outlen) ".dats"
  write_dats_header(f)
  print > f
  print "implement" > f
  print "siphash_c_d_" (8 * outlen) " (input, inlen, key, crounds, drounds) =" > f
  print "  let" > f
  print "    implement siphash$crounds<> () = crounds" > f
  print "    implement siphash$drounds<> () = drounds" > f
  print "  in" > f
  print "    siphash_" (8 * outlen) "<> (input, inlen, key)" > f
  print "  end" > f
}

function write_dats_m_n_output(crounds, drounds,  f)
{
  system("mkdir -p siphash/DATS")
  f = "siphash/DATS/siphash_" crounds "_" drounds "_output.dats"
  write_dats_header(f)
  print > f
  print "local" > f
  print "  implement siphash$crounds<> () = " crounds "U" > f
  print "  implement siphash$drounds<> () = " drounds "U" > f
  print "in" > f
  print "  implement" > f
  print "  siphash_" crounds "_" drounds "_output (input, inlen, key, output, outlen) =" > f
  print "    siphash<> (input, inlen, key, output, outlen)" > f
  print "end" > f
}

function write_dats_c_d_output( f)
{
  system("mkdir -p siphash/DATS")
  f = "siphash/DATS/siphash_c_d_output.dats"
  write_dats_header(f)
  print > f
  print "implement" > f
  print "siphash_c_d_output (input, inlen, key, crounds, drounds," > f
  print "                    output, outlen) =" > f
  print "  let" > f
  print "    implement siphash$crounds<> () = crounds" > f
  print "    implement siphash$drounds<> () = drounds" > f
  print "  in" > f
  print "    siphash<> (input, inlen, key, output, outlen)" > f
  print "  end" > f
}

function write_dats_header(f)
{
  write_generated(f)
  print > f
  print "#define ATS_PACKNAME \"ats2-siphash\"" > f
  print "#define ATS_EXTERN_PREFIX \"ats2_siphash_\"" > f
  print > f
  print "#define ATS_DYNLOADFLAG 0" > f
  print > f
  print "#include \"share/atspre_define.hats\"" > f
  print "#include \"share/atspre_staload.hats\"" > f
  print > f
  print "staload \"siphash/SATS/array_prf.sats\"" > f
  print "staload \"siphash/SATS/siphash.sats\"" > f
  print "staload _ = \"siphash/DATS/siphash.dats\"" > f
}

function write_generated(f)
{
  print "(* This file was generated by an awk script. *)" > f
}
