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

M4_DEPS =

AM_M4FLAGS =

TOTAL_M4FLAGS =
TOTAL_M4FLAGS += $(AM_M4FLAGS)
TOTAL_M4FLAGS += $(M4FLAGS)
TOTAL_M4FLAGS += $(XM4FLAGS)

%: %.m4 common-macros.m4
	@$(MKDIR_P) $(@D)
	$(call v,M4)$(M4) $(TOTAL_M4FLAGS) $(<) > $(@)

%.c: %.c.m4 common-macros.m4
	@$(MKDIR_P) $(@D)
	$(call v,M4)$(M4) $(TOTAL_M4FLAGS) $(<) > $(@)

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
#
# The ATS2 library.
#

lib_LTLIBRARIES += libats2-siphash.la

ARRAY_PRF_SATS = siphash/SATS/array_prf.sats
ARRAY_PRF_SATS_C = siphash/SATS/array_prf_sats.c
EXTRA_DIST += $(ARRAY_PRF_SATS)
CLEANFILES += $(ARRAY_PRF_SATS_C)

ARRAY_PRF_DATS = siphash/DATS/array_prf.dats
ARRAY_PRF_DATS_C = siphash/DATS/array_prf_dats.c
EXTRA_DIST += $(ARRAY_PRF_DATS)
CLEANFILES += $(ARRAY_PRF_DATS_C)

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
nodist_libats2_siphash_la_SOURCES += $(ARRAY_PRF_SATS_C)
nodist_libats2_siphash_la_SOURCES += $(ARRAY_PRF_DATS_C)
nodist_libats2_siphash_la_SOURCES += $(SIPHASH_SATS_C)
nodist_libats2_siphash_la_SOURCES += $(SIPHASH_DATS_C)

$(ARRAY_PRF_SATS_C): $(ARRAY_PRF_SATS)
$(ARRAY_PRF_DATS_C): $(ARRAY_PRF_SATS) $(ARRAY_PRF_DATS)
$(SIPHASH_SATS_C): $(SIPHASH_SATS)
$(SIPHASH_DATS_C): $(SIPHASH_SATS) $(SIPHASH_DATS) $(SIPHASH_CATS) \
					$(ARRAY_PRF_SATS)

nobase_nodist_pkginclude_HEADERS += $(ARRAY_PRF_SATS)
nobase_nodist_pkginclude_HEADERS += $(ARRAY_PRF_DATS)
nobase_nodist_pkginclude_HEADERS += $(SIPHASH_CATS)
nobase_nodist_pkginclude_HEADERS += $(SIPHASH_SATS)
nobase_nodist_pkginclude_HEADERS += $(SIPHASH_DATS)

#--------------------------------------------------------------------------
#
# The C library.
#

lib_LTLIBRARIES += libsiphash.la

SIPHASH_C_DATS = siphash/DATS/siphash_c.dats
SIPHASH_C_DATS_C = siphash/DATS/siphash_c_dats.c
EXTRA_DIST += $(SIPHASH_C_DATS)
CLEANFILES += $(SIPHASH_C_DATS_C)

libsiphash_la_SOURCES =
libsiphash_la_SOURCES += $(SIPHASH_C_DATS_C)
libsiphash_la_SOURCES += siphash/siphash.h

libsiphash_la_LIBADD =
libsiphash_la_LIBADD += libats2-siphash.la

nobase_nodist_pkginclude_HEADERS += $(SIPHASH_32_C_DATS)
nobase_nodist_pkginclude_HEADERS += siphash/siphash.h

# #--------------------------------------------------------------------------
# 
# pkgconfigdir = ${libdir}/pkgconfig
# nodist_pkgconfig_DATA = ats2-murmurhash3.pc
# nodist_pkgconfig_DATA = murmurhash3.pc
# 
# #--------------------------------------------------------------------------

AM_DEFAULT_SOURCE_EXT = _dats.c

TESTS =
TESTS += $(check_PROGRAMS)

DISTRIBUTED_ATS2_TESTS =

M4_GENERATED_ATS2_TESTS =
M4_GENERATED_ATS2_TESTS += tests/test-siphash-2-4-64
M4_GENERATED_ATS2_TESTS += tests/test-siphash-2-4-128

tests_test_siphash_2_4_64_SOURCES =
tests_test_siphash_2_4_64_SOURCES += tests/test-siphash-2-4-64_dats.c
tests_test_siphash_2_4_64_SOURCES += tests/vectors_sats.c
tests_test_siphash_2_4_64_SOURCES += tests/vectors_dats.c
tests_test_siphash_2_4_64_LDADD =
tests_test_siphash_2_4_64_LDADD += libats2-siphash.la
tests_test_siphash_2_4_64_DEPENDENCIES =
tests_test_siphash_2_4_64_DEPENDENCIES += tests/vectors-2-4.h
tests_test_siphash_2_4_64_DEPENDENCIES += siphash/SATS/array_prf.sats

tests_test_siphash_2_4_128_SOURCES =
tests_test_siphash_2_4_128_SOURCES += tests/test-siphash-2-4-128_dats.c
tests_test_siphash_2_4_128_SOURCES += tests/vectors_sats.c
tests_test_siphash_2_4_128_SOURCES += tests/vectors_dats.c
tests_test_siphash_2_4_128_LDADD =
tests_test_siphash_2_4_128_LDADD += libats2-siphash.la
tests_test_siphash_2_4_128_DEPENDENCIES =
tests_test_siphash_2_4_128_DEPENDENCIES += tests/vectors-2-4.h
tests_test_siphash_2_4_128_DEPENDENCIES += siphash/SATS/array_prf.sats

tests/vectors_sats.c: tests/vectors.sats
tests/vectors_dats.c: tests/vectors.dats tests/vectors.sats
EXTRA_DIST += tests/vectors.sats tests/vectors.dats
CLEANFILES += tests/vectors_sats.c tests/vectors_dats.c

DISTRIBUTED_C_TESTS =

M4_GENERATED_C_TESTS =
M4_GENERATED_C_TESTS += tests/test-siphash-2-4-64-C
M4_GENERATED_C_TESTS += tests/test-siphash-2-4-128-C

tests_test_siphash_2_4_64_C_SOURCES =
tests_test_siphash_2_4_64_C_SOURCES += tests/test-siphash-2-4-64-C.c
tests_test_siphash_2_4_64_C_SOURCES += tests/vectors-2-4.h
tests_test_siphash_2_4_64_C_LDADD =
tests_test_siphash_2_4_64_C_LDADD += libsiphash.la

tests_test_siphash_2_4_128_C_SOURCES =
tests_test_siphash_2_4_128_C_SOURCES += tests/test-siphash-2-4-128-C.c
tests_test_siphash_2_4_128_C_SOURCES += tests/vectors-2-4.h
tests_test_siphash_2_4_128_C_LDADD =
tests_test_siphash_2_4_128_C_LDADD += libsiphash.la

DISTRIBUTED_TESTS =
DISTRIBUTED_TESTS += $(DISTRIBUTED_ATS2_TESTS)
DISTRIBUTED_TESTS += $(DISTRIBUTED_C_TESTS)

GENERATED_TESTS =
GENERATED_TESTS += $(M4_GENERATED_ATS2_TESTS)
GENERATED_TESTS += $(M4_GENERATED_C_TESTS)

check_PROGRAMS =
check_PROGRAMS += $(DISTRIBUTED_TESTS)
check_PROGRAMS += $(GENERATED_TESTS)

EXTRA_DIST += $(DISTRIBUTED_ATS2_TESTS:%=%.dats)
EXTRA_DIST += $(M4_GENERATED_ATS2_TESTS:%=%.dats.m4)
EXTRA_DIST += $(DISTRIBUTED_C_TESTS:%=%.c)
EXTRA_DIST += $(M4_GENERATED_C_TESTS:%=%.c.m4)

CLEANFILES += $(DISTRIBUTED_ATS2_TESTS:%=%_dats.c)
CLEANFILES += $(M4_GENERATED_ATS2_TESTS:%=%.dats)
CLEANFILES += $(M4_GENERATED_ATS2_TESTS:%=%_dats.c)
CLEANFILES += $(M4_GENERATED_C_TESTS:%=%.c)

$(foreach f,$(M4_GENERATED_ATS2_TESTS), \
	$(eval $(f:%=%.dats) $(f:%=%_dats.c): $(f:%=%.dats.m4)))

$(foreach f,$(M4_GENERATED_C_TESTS), \
	$(eval $(f:%=%.c): $(f:%=%.c.m4)))

#--------------------------------------------------------------------------

EXTRA_DIST += reference-implementation/halfsiphash.c
EXTRA_DIST += reference-implementation/halfsiphash.h
EXTRA_DIST += reference-implementation/LICENSE
EXTRA_DIST += reference-implementation/makefile
EXTRA_DIST += reference-implementation/README.md
EXTRA_DIST += reference-implementation/siphash.c
EXTRA_DIST += reference-implementation/siphash.h
EXTRA_DIST += reference-implementation/test.c
EXTRA_DIST += reference-implementation/testmain.c
EXTRA_DIST += reference-implementation/vectors.h

#--------------------------------------------------------------------------
# local variables:
# coding: utf-8
# end:
