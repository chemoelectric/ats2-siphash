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
#

.DELETE_ON_ERROR:

ACLOCAL_AMFLAGS = -I m4 --install
AUTOMAKE_OPTIONS =
AUTOMAKE_OPTIONS += foreign
AUTOMAKE_OPTIONS += subdir-objects
AUTOMAKE_OPTIONS += -Wno-portability

include $(top_srcdir)/aminclude_static.am
@GNU@ include $(srcdir)/silent-rules.mk

EXTRA_DIST =
MOSTLYCLEANFILES =
CLEANFILES =
DISTCLEANFILES =
BUILT_SOURCES =
AM_CPPFLAGS =
AM_CFLAGS =
AM_LDFLAGS =
LDADD =
bin_PROGRAMS =
lib_LTLIBRARIES =
nobase_nodist_pkginclude_HEADERS =

EXTRA_DIST += $(srcdir)/silent-rules.mk
EXTRA_DIST += COPYING
EXTRA_DIST += INSTALL
EXTRA_DIST += README
EXTRA_DIST += AUTHORS

DISTCLEANFILES += Makefile

# We will not be using exceptions.
AM_CPPFLAGS += -D_ATS_CCOMP_EXCEPTION_NONE

AM_CPPFLAGS += -I$(builddir)
AM_CPPFLAGS += -I$(srcdir)
AM_CPPFLAGS += -I$(PATSHOME)
AM_CPPFLAGS += -I$(PATSHOME)/ccomp/runtime/

LDADD += $(CODE_COVERAGE_LIBS)

CODE_COVERAGE_IGNORE_PATTERN =
CODE_COVERAGE_IGNORE_PATTERN += /usr/include/*
CODE_COVERAGE_IGNORE_PATTERN += /usr/include/*/*
CODE_COVERAGE_IGNORE_PATTERN += $(PATSHOME)/ccomp/runtime/*
CODE_COVERAGE_IGNORE_PATTERN += $(PATSHOME)/prelude/CATS/*

clean-local: code-coverage-clean
distclean-local: code-coverage-dist-clean

#---------------------------------------------------------------------
#
# Some GNU Make aids you might want to use.
#

comma := ,
empty :=
space := $(empty) $(empty)

# Escape things for sed expressions, etc.
escape = $(subst $$,\$$,$(subst ^,\^,$(subst ],\],$(subst [,\[,$(subst .,\.,$(subst \,\\,$(1)))))))

#--------------------------------------------------------------------------

PATSOPT_DEPS =

AM_PATSOPTFLAGS =
AM_PATSOPTFLAGS += -IATS $(builddir)
AM_PATSOPTFLAGS += -IATS $(srcdir)

TOTAL_PATSOPTFLAGS =
TOTAL_PATSOPTFLAGS += $(AM_PATSOPTFLAGS)
TOTAL_PATSOPTFLAGS += $(PATSOPTFLAGS)
TOTAL_PATSOPTFLAGS += $(XPATSOPTFLAGS)

%_sats.c: %.sats $(PATSOPT_DEPS)
	@$(MKDIR_P) $(@D)
	$(call v,PATSOPT)$(PATSOPT) -o $(@) $(TOTAL_PATSOPTFLAGS) -s $(<)

%_dats.c: %.dats $(PATSOPT_DEPS)
	@$(MKDIR_P) $(@D)
	$(call v,PATSOPT)$(PATSOPT) -o $(@) $(TOTAL_PATSOPTFLAGS) -d $(<)

#--------------------------------------------------------------------------

lib_LTLIBRARIES += libats2-siphash.la

SIPHASH_SATS = siphash/SATS/siphash.sats
SIPHASH_SATS_C = siphash/SATS/siphash_sats.c
EXTRA_DIST += $(SIPHASH_SATS)
CLEANFILES += $(SIPHASH_SATS_C)

SIPHASH_DATS = siphash/DATS/siphash.dats
SIPHASH_DATS_C = siphash/DATS/siphash_dats.c
EXTRA_DIST += $(SIPHASH_DATS)
CLEANFILES += $(SIPHASH_DATS_C)

SIPHASH_CATS = siphash/CATS/siphash.cats
EXTRA_DIST += $(SIPHASH_CATS)

nodist_libats2_siphash_la_SOURCES =
nodist_libats2_siphash_la_SOURCES += $(SIPHASH_SATS_C)
nodist_libats2_siphash_la_SOURCES += $(SIPHASH_DATS_C)

$(SIPHASH_SATS_C): $(SIPHASH_SATS)
$(SIPHASH_DATS_C): $(SIPHASH_SATS) $(SIPHASH_DATS) $(SIPHASH_CATS)

nobase_nodist_pkginclude_HEADERS += $(SIPHASH_CATS)
nobase_nodist_pkginclude_HEADERS += $(SIPHASH_SATS)
nobase_nodist_pkginclude_HEADERS += $(SIPHASH_DATS)

# #--------------------------------------------------------------------------
# #
# # The ATS2 library.
# #
# 
# lib_LTLIBRARIES += libats2-murmurhash3.la
# 
# ARRAY_PRF_SATS = murmurhash3/SATS/array_prf.sats
# ARRAY_PRF_SATS_C = murmurhash3/SATS/array_prf_sats.c
# EXTRA_DIST += $(ARRAY_PRF_SATS)
# CLEANFILES += $(ARRAY_PRF_SATS_C)
# 
# ARRAY_PRF_DATS = murmurhash3/DATS/array_prf.dats
# ARRAY_PRF_DATS_C = murmurhash3/DATS/array_prf_dats.c
# EXTRA_DIST += $(ARRAY_PRF_DATS)
# CLEANFILES += $(ARRAY_PRF_DATS_C)
# 
# MURMURHASH3_CATS = murmurhash3/CATS/murmurhash3.cats
# EXTRA_DIST += $(MURMURHASH3_CATS)
# 
# MURMURHASH3_32_SATS = murmurhash3/SATS/murmurhash3_32.sats
# MURMURHASH3_32_SATS_C = murmurhash3/SATS/murmurhash3_32_sats.c
# EXTRA_DIST += $(MURMURHASH3_32_SATS)
# CLEANFILES += $(MURMURHASH3_32_SATS_C)
# 
# MURMURHASH3_32_DATS = murmurhash3/DATS/murmurhash3_32.dats
# MURMURHASH3_32_DATS_C = murmurhash3/DATS/murmurhash3_32_dats.c
# EXTRA_DIST += $(MURMURHASH3_32_DATS)
# CLEANFILES += $(MURMURHASH3_32_DATS_C)
# 
# MURMURHASH3_32_STRING_DATS = murmurhash3/DATS/murmurhash3_32_string.dats
# MURMURHASH3_32_STRING_DATS_C = murmurhash3/DATS/murmurhash3_32_string_dats.c
# EXTRA_DIST += $(MURMURHASH3_32_STRING_DATS)
# CLEANFILES += $(MURMURHASH3_32_STRING_DATS_C)
# 
# MURMURHASH3_32_LIST_DATS = murmurhash3/DATS/murmurhash3_32_list.dats
# MURMURHASH3_32_LIST_DATS_C = murmurhash3/DATS/murmurhash3_32_list_dats.c
# EXTRA_DIST += $(MURMURHASH3_32_LIST_DATS)
# CLEANFILES += $(MURMURHASH3_32_LIST_DATS_C)
# 
# MURMURHASH3_32_HATS = murmurhash3/HATS/murmurhash3_32.hats
# EXTRA_DIST += $(MURMURHASH3_32_HATS)
# 
# nodist_libats2_murmurhash3_la_SOURCES =
# nodist_libats2_murmurhash3_la_SOURCES += $(ARRAY_PRF_SATS_C)
# nodist_libats2_murmurhash3_la_SOURCES += $(ARRAY_PRF_DATS_C)
# nodist_libats2_murmurhash3_la_SOURCES += $(MURMURHASH3_32_SATS_C)
# nodist_libats2_murmurhash3_la_SOURCES += $(MURMURHASH3_32_DATS_C)
# nodist_libats2_murmurhash3_la_SOURCES += $(MURMURHASH3_32_STRING_DATS_C)
# nodist_libats2_murmurhash3_la_SOURCES += $(MURMURHASH3_32_LIST_DATS_C)
# 
# $(ARRAY_PRF_SATS_C): $(ARRAY_PRF_SATS)
# $(ARRAY_PRF_DATS_C): $(ARRAY_PRF_DATS) $(ARRAY_PRF_SATS)
# $(MURMURHASH3_32_SATS_C): $(MURMURHASH3_32_SATS)
# $(MURMURHASH3_32_DATS_C): $(MURMURHASH3_32_DATS) \
# 							$(MURMURHASH3_32_SATS) \
# 							$(MURMURHASH3_CATS) \
# 						 	$(ARRAY_PRF_SATS)
# $(MURMURHASH3_32_STRING_DATS_C): $(MURMURHASH3_32_STRING_DATS) \
# 							$(MURMURHASH3_32_SATS)
# $(MURMURHASH3_32_LIST_DATS_C): $(MURMURHASH3_32_LIST_DATS) \
# 							$(MURMURHASH3_32_SATS)
# 
# nobase_nodist_pkginclude_HEADERS += $(ARRAY_PRF_SATS)
# nobase_nodist_pkginclude_HEADERS += $(ARRAY_PRF_DATS)
# nobase_nodist_pkginclude_HEADERS += $(MURMURHASH3_CATS)
# nobase_nodist_pkginclude_HEADERS += $(MURMURHASH3_32_SATS)
# nobase_nodist_pkginclude_HEADERS += $(MURMURHASH3_32_DATS)
# nobase_nodist_pkginclude_HEADERS += $(MURMURHASH3_32_STRING_DATS)
# nobase_nodist_pkginclude_HEADERS += $(MURMURHASH3_32_LIST_DATS)
# nobase_nodist_pkginclude_HEADERS += $(MURMURHASH3_32_HATS)
# 
# #--------------------------------------------------------------------------
# #
# # The C library.
# #
# 
# lib_LTLIBRARIES += libmurmurhash3.la
# 
# MURMURHASH3_32_C_DATS = murmurhash3/DATS/murmurhash3_32_c.dats
# MURMURHASH3_32_C_DATS_C = murmurhash3/DATS/murmurhash3_32_c_dats.c
# EXTRA_DIST += $(MURMURHASH3_32_C_DATS)
# CLEANFILES += $(MURMURHASH3_32_C_DATS_C)
# 
# libmurmurhash3_la_SOURCES =
# libmurmurhash3_la_SOURCES += $(MURMURHASH3_32_C_DATS_C)
# libmurmurhash3_la_SOURCES += murmurhash3/murmurhash3_32.h
# 
# libmurmurhash3_la_LIBADD =
# libmurmurhash3_la_LIBADD += libats2-murmurhash3.la
# 
# nobase_nodist_pkginclude_HEADERS += $(MURMURHASH3_32_C_DATS)
# nobase_nodist_pkginclude_HEADERS += murmurhash3/murmurhash3_32.h
# 
# #--------------------------------------------------------------------------
# 
# pkgconfigdir = ${libdir}/pkgconfig
# nodist_pkgconfig_DATA = ats2-murmurhash3.pc
# nodist_pkgconfig_DATA = murmurhash3.pc
# 
# #--------------------------------------------------------------------------
# 
# AM_DEFAULT_SOURCE_EXT = _dats.c
# 
# TESTS =
# TESTS += $(check_PROGRAMS)
# 
# DISTRIBUTED_ATS2_TESTS =
# DISTRIBUTED_ATS2_TESTS += tests/test_murmurhash3_32
# DISTRIBUTED_ATS2_TESTS += tests/test_murmurhash3_32_list
# DISTRIBUTED_ATS2_TESTS += tests/test_murmurhash3_32_list_vt
# 
# tests_test_murmurhash3_32_LDADD = libats2-murmurhash3.la
# 
# tests_test_murmurhash3_32_list_LDADD = libats2-murmurhash3.la
# tests_test_murmurhash3_32_list_DEPENDENCIES = $(MURMURHASH3_32_HATS)
# 
# tests_test_murmurhash3_32_list_vt_LDADD = libats2-murmurhash3.la
# tests_test_murmurhash3_32_list_vt_DEPENDENCIES = $(MURMURHASH3_32_HATS)
# 
# DISTRIBUTED_C_TESTS =
# DISTRIBUTED_C_TESTS += tests/test_murmurhash3_32_c
# 
# tests_test_murmurhash3_32_c_SOURCES = tests/test_murmurhash3_32_c.c
# tests_test_murmurhash3_32_c_LDADD = libmurmurhash3.la
# 
# DISTRIBUTED_TESTS =
# DISTRIBUTED_TESTS += $(DISTRIBUTED_ATS2_TESTS)
# DISTRIBUTED_TESTS += $(DISTRIBUTED_C_TESTS)
# 
# check_PROGRAMS =
# check_PROGRAMS += $(DISTRIBUTED_TESTS)
# 
# EXTRA_DIST += $(DISTRIBUTED_ATS2_TESTS:%=%.dats)
# CLEANFILES += $(DISTRIBUTED_ATS2_TESTS:%=%_dats.c)

#--------------------------------------------------------------------------
# local variables:
# coding: utf-8
# end:
