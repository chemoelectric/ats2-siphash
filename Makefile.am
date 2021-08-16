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

SUBDIRS = lib

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
nodist_pkgconfig_DATA =

EXTRA_DIST += $(srcdir)/silent-rules.mk
EXTRA_DIST += COPYING
EXTRA_DIST += INSTALL
EXTRA_DIST += README
EXTRA_DIST += AUTHORS

DISTCLEANFILES += Makefile
DISTCLEANFILES += GNUmakefile
DISTCLEANFILES += lib/Makefile
DISTCLEANFILES += lib/GNUmakefile

# We will not be using exceptions.
AM_CPPFLAGS += -D_ATS_CCOMP_EXCEPTION_NONE

AM_CPPFLAGS += -I$(builddir)
AM_CPPFLAGS += -I$(srcdir)
AM_CPPFLAGS += -I$(PATSHOME)
AM_CPPFLAGS += -I$(PATSHOME)/ccomp/runtime/
AM_CPPFLAGS += -I$(builddir)/lib
AM_CPPFLAGS += -I$(srcdir)/lib

LDADD += $(CODE_COVERAGE_LIBS)

CODE_COVERAGE_IGNORE_PATTERN =
CODE_COVERAGE_IGNORE_PATTERN += /usr/include/*
CODE_COVERAGE_IGNORE_PATTERN += /usr/include/*/*
CODE_COVERAGE_IGNORE_PATTERN += $(PATSHOME)/ccomp/runtime/*
CODE_COVERAGE_IGNORE_PATTERN += $(PATSHOME)/prelude/CATS/*

clean-local: code-coverage-clean
distclean-local: code-coverage-dist-clean

EXTRA_DIST += $(srcdir)/write-siphash-implementations.awk
config.status: $(srcdir)/write-siphash-implementations.awk

EXTRA_DIST += $(srcdir)/write-halfsiphash-implementations.awk
config.status: $(srcdir)/write-halfsiphash-implementations.awk

EXTRA_DIST += m4/gnulib-cache.m4

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

libats2_siphash_la_LDFLAGS =
libats2_siphash_la_LDFLAGS += $(LIB_GETRANDOM)

ARRAY_PRF_SATS = siphash/SATS/array_prf.sats
ARRAY_PRF_SATS_C = siphash/SATS/array_prf_sats.c
EXTRA_DIST += $(ARRAY_PRF_SATS)
CLEANFILES += $(ARRAY_PRF_SATS_C)

ARRAY_PRF_DATS = siphash/DATS/array_prf.dats
ARRAY_PRF_DATS_C = siphash/DATS/array_prf_dats.c
EXTRA_DIST += $(ARRAY_PRF_DATS)
CLEANFILES += $(ARRAY_PRF_DATS_C)

SIPHASH_SATS = siphash/SATS/siphash.sats $(SIPHASH_SATS_EXTRA)
SIPHASH_SATS_EXTRA = siphash/SATS/include/siphash-implementations.inc
SIPHASH_SATS_C = siphash/SATS/siphash_sats.c
EXTRA_DIST += $(SIPHASH_SATS)
CLEANFILES += $(SIPHASH_SATS_C)
DISTCLEANFILES += $(SIPHASH_SATS_EXTRA)

SIPHASH_DATS = siphash/DATS/siphash.dats $(SIPHASH_DATS_EXTRA)
SIPHASH_DATS_EXTRA =
SIPHASH_DATS_EXTRA += siphash/DATS/siphash_2_4_64.dats
SIPHASH_DATS_EXTRA += siphash/DATS/siphash_2_4_128.dats
SIPHASH_DATS_EXTRA += siphash/DATS/siphash_2_4_output.dats
SIPHASH_DATS_EXTRA += siphash/DATS/siphash_4_8_64.dats
SIPHASH_DATS_EXTRA += siphash/DATS/siphash_4_8_128.dats
SIPHASH_DATS_EXTRA += siphash/DATS/siphash_4_8_output.dats
SIPHASH_DATS_EXTRA += siphash/DATS/siphash_c_d_64.dats
SIPHASH_DATS_EXTRA += siphash/DATS/siphash_c_d_128.dats
SIPHASH_DATS_EXTRA += siphash/DATS/siphash_c_d_output.dats
SIPHASH_DATS_C =
SIPHASH_DATS_C += siphash/DATS/siphash_dats.c
SIPHASH_DATS_C += siphash/DATS/siphash_2_4_64_dats.c
SIPHASH_DATS_C += siphash/DATS/siphash_2_4_128_dats.c
SIPHASH_DATS_C += siphash/DATS/siphash_2_4_output_dats.c
SIPHASH_DATS_C += siphash/DATS/siphash_4_8_64_dats.c
SIPHASH_DATS_C += siphash/DATS/siphash_4_8_128_dats.c
SIPHASH_DATS_C += siphash/DATS/siphash_4_8_output_dats.c
SIPHASH_DATS_C += siphash/DATS/siphash_c_d_64_dats.c
SIPHASH_DATS_C += siphash/DATS/siphash_c_d_128_dats.c
SIPHASH_DATS_C += siphash/DATS/siphash_c_d_output_dats.c
EXTRA_DIST += $(SIPHASH_DATS)
CLEANFILES += $(SIPHASH_DATS_C)
DISTCLEANFILES += $(SIPHASH_DATS_EXTRA)

HALFSIPHASH_SATS = siphash/SATS/halfsiphash.sats $(HALFSIPHASH_SATS_EXTRA)
HALFSIPHASH_SATS_EXTRA = siphash/SATS/include/halfsiphash-implementations.inc
HALFSIPHASH_SATS_C = siphash/SATS/halfsiphash_sats.c
EXTRA_DIST += $(HALFSIPHASH_SATS)
CLEANFILES += $(HALFSIPHASH_SATS_C)
DISTCLEANFILES += $(HALFSIPHASH_SATS_EXTRA)

HALFSIPHASH_DATS = siphash/DATS/halfsiphash.dats $(HALFSIPHASH_DATS_EXTRA)
HALFSIPHASH_DATS_EXTRA =
HALFSIPHASH_DATS_EXTRA += siphash/DATS/halfsiphash_2_4_32.dats
HALFSIPHASH_DATS_EXTRA += siphash/DATS/halfsiphash_2_4_64.dats
HALFSIPHASH_DATS_EXTRA += siphash/DATS/halfsiphash_2_4_output.dats
HALFSIPHASH_DATS_EXTRA += siphash/DATS/halfsiphash_4_8_32.dats
HALFSIPHASH_DATS_EXTRA += siphash/DATS/halfsiphash_4_8_64.dats
HALFSIPHASH_DATS_EXTRA += siphash/DATS/halfsiphash_4_8_output.dats
HALFSIPHASH_DATS_EXTRA += siphash/DATS/halfsiphash_c_d_32.dats
HALFSIPHASH_DATS_EXTRA += siphash/DATS/halfsiphash_c_d_64.dats
HALFSIPHASH_DATS_EXTRA += siphash/DATS/halfsiphash_c_d_output.dats
HALFSIPHASH_DATS_C =
HALFSIPHASH_DATS_C += siphash/DATS/halfsiphash_dats.c
HALFSIPHASH_DATS_C += siphash/DATS/halfsiphash_2_4_32_dats.c
HALFSIPHASH_DATS_C += siphash/DATS/halfsiphash_2_4_64_dats.c
HALFSIPHASH_DATS_C += siphash/DATS/halfsiphash_2_4_output_dats.c
HALFSIPHASH_DATS_C += siphash/DATS/halfsiphash_4_8_32_dats.c
HALFSIPHASH_DATS_C += siphash/DATS/halfsiphash_4_8_64_dats.c
HALFSIPHASH_DATS_C += siphash/DATS/halfsiphash_4_8_output_dats.c
HALFSIPHASH_DATS_C += siphash/DATS/halfsiphash_c_d_32_dats.c
HALFSIPHASH_DATS_C += siphash/DATS/halfsiphash_c_d_64_dats.c
HALFSIPHASH_DATS_C += siphash/DATS/halfsiphash_c_d_output_dats.c
EXTRA_DIST += $(HALFSIPHASH_DATS)
CLEANFILES += $(HALFSIPHASH_DATS_C)
DISTCLEANFILES += $(HALFSIPHASH_DATS_EXTRA)

KEY_SATS = siphash/SATS/key.sats
KEY_SATS_C = siphash/SATS/key_sats.c
EXTRA_DIST += $(KEY_SATS)
CLEANFILES += $(KEY_SATS_C)

KEY_DATS = siphash/DATS/key.dats
KEY_DATS_C = siphash/DATS/key_dats.c
EXTRA_DIST += $(KEY_DATS)
CLEANFILES += $(KEY_DATS_C)

ATOMIC_CATS = siphash/CATS/atomic.cats
ATOMIC_CATS += siphash/CATS/spinlock.cats
ATOMIC_SATS = siphash/SATS/atomic.sats
ATOMIC_SATS += siphash/SATS/spinlock.sats
ATOMIC_SATS += siphash/SATS/initialize_once.sats
ATOMIC_DATS = siphash/DATS/atomic.dats
ATOMIC_DATS += siphash/DATS/spinlock.dats
ATOMIC_DATS += siphash/DATS/initialize_once.dats
ATOMIC_SATS_C = siphash/SATS/atomic_sats.c
ATOMIC_SATS_C += siphash/SATS/spinlock_sats.c
ATOMIC_SATS_C += siphash/SATS/initialize_once_sats.c
ATOMIC_DATS_C = siphash/DATS/atomic_dats.c
ATOMIC_DATS_C += siphash/DATS/spinlock_dats.c
ATOMIC_DATS_C += siphash/DATS/initialize_once_dats.c
EXTRA_DIST += $(ATOMIC_CATS)
EXTRA_DIST += $(ATOMIC_SATS)
EXTRA_DIST += $(ATOMIC_DATS)
CLEANFILES += $(ATOMIC_SATS_C)
CLEANFILES += $(ATOMIC_DATS_C)

SIPHASH_CATS = siphash/CATS/siphash.cats
EXTRA_DIST += $(SIPHASH_CATS)

SIPHASH_HATS = siphash/HATS/siphash.hats
EXTRA_DIST += $(SIPHASH_HATS)

HALFSIPHASH_HATS = siphash/HATS/halfsiphash.hats
EXTRA_DIST += $(HALFSIPHASH_HATS)

nodist_libats2_siphash_la_SOURCES =
nodist_libats2_siphash_la_SOURCES += $(ARRAY_PRF_SATS_C)
nodist_libats2_siphash_la_SOURCES += $(ARRAY_PRF_DATS_C)
nodist_libats2_siphash_la_SOURCES += $(SIPHASH_SATS_C)
nodist_libats2_siphash_la_SOURCES += $(SIPHASH_DATS_C)
nodist_libats2_siphash_la_SOURCES += $(HALFSIPHASH_SATS_C)
nodist_libats2_siphash_la_SOURCES += $(HALFSIPHASH_DATS_C)
nodist_libats2_siphash_la_SOURCES += $(KEY_SATS_C)
nodist_libats2_siphash_la_SOURCES += $(KEY_DATS_C)
nodist_libats2_siphash_la_SOURCES += $(ATOMIC_SATS_C)
nodist_libats2_siphash_la_SOURCES += $(ATOMIC_DATS_C)

$(ARRAY_PRF_SATS_C): $(ARRAY_PRF_SATS)
$(ARRAY_PRF_DATS_C): $(ARRAY_PRF_SATS) $(ARRAY_PRF_DATS)
$(SIPHASH_SATS_C): $(SIPHASH_SATS)
$(SIPHASH_DATS_C): $(SIPHASH_SATS) $(SIPHASH_DATS) \
						$(SIPHASH_CATS)	$(ARRAY_PRF_SATS)
$(HALFSIPHASH_SATS_C): $(HALFSIPHASH_SATS)
$(HALFSIPHASH_DATS_C): $(HALFSIPHASH_SATS) $(HALFSIPHASH_DATS) \
						$(SIPHASH_CATS) $(ARRAY_PRF_SATS)
$(KEY_SATS_C): $(KEY_SATS)
$(KEY_DATS_C): $(KEY_SATS) $(KEY_DATS) \
					$(ATOMIC_SATS) $(ATOMIC_DATS) $(ATOMIC_CATS) \
					config.h

siphash/SATS/atomic_sats.c: siphash/SATS/atomic.sats
siphash/SATS/atomic_sats.c: siphash/CATS/atomic.cats
siphash/SATS/atomic_sats.c: $(SIPHASH_CATS)
siphash/SATS/spinlock_sats.c: siphash/SATS/spinlock.sats
siphash/SATS/spinlock_sats.c: siphash/CATS/spinlock.cats
siphash/SATS/spinlock_sats.c: siphash/SATS/atomic.sats
siphash/SATS/spinlock_sats.c: siphash/CATS/atomic.cats
siphash/SATS/spinlock_sats.c: $(SIPHASH_CATS)
siphash/SATS/initialize_once_sats.c: siphash/SATS/initialize_once.sats
siphash/SATS/initialize_once_sats.c: siphash/SATS/spinlock.sats
siphash/SATS/initialize_once_sats.c: siphash/CATS/spinlock.cats
siphash/SATS/initialize_once_sats.c: siphash/SATS/atomic.sats
siphash/SATS/initialize_once_sats.c: siphash/CATS/atomic.cats
siphash/SATS/initialize_once_sats.c: $(SIPHASH_CATS)

siphash/DATS/atomic_dats.c: siphash/DATS/atomic.dats
siphash/DATS/atomic_dats.c: siphash/SATS/atomic.sats
siphash/DATS/atomic_dats.c: siphash/CATS/atomic.cats
siphash/DATS/atomic_dats.c: $(SIPHASH_CATS)
siphash/DATS/spinlock_dats.c: siphash/DATS/spinlock.dats
siphash/DATS/spinlock_dats.c: siphash/DATS/atomic.dats
siphash/DATS/spinlock_dats.c: siphash/SATS/spinlock.sats
siphash/DATS/spinlock_dats.c: siphash/SATS/atomic.sats
siphash/DATS/spinlock_dats.c: siphash/CATS/spinlock.cats
siphash/DATS/spinlock_dats.c: siphash/CATS/atomic.cats
siphash/DATS/spinlock_dats.c: $(SIPHASH_CATS)
siphash/DATS/initialize_once_dats.c: siphash/DATS/initialize_once.dats
siphash/DATS/initialize_once_dats.c: siphash/DATS/spinlock.dats
siphash/DATS/initialize_once_dats.c: siphash/DATS/atomic.dats
siphash/DATS/initialize_once_dats.c: siphash/SATS/initialize_once.sats
siphash/DATS/initialize_once_dats.c: siphash/SATS/spinlock.sats
siphash/DATS/initialize_once_dats.c: siphash/SATS/atomic.sats
siphash/DATS/initialize_once_dats.c: siphash/CATS/spinlock.cats
siphash/DATS/initialize_once_dats.c: siphash/CATS/atomic.cats
siphash/DATS/initialize_once_dats.c: $(SIPHASH_CATS)

nobase_nodist_pkginclude_HEADERS += $(ARRAY_PRF_SATS)
nobase_nodist_pkginclude_HEADERS += $(ARRAY_PRF_DATS)
nobase_nodist_pkginclude_HEADERS += $(SIPHASH_CATS)
nobase_nodist_pkginclude_HEADERS += $(SIPHASH_SATS)
nobase_nodist_pkginclude_HEADERS += $(SIPHASH_DATS)
nobase_nodist_pkginclude_HEADERS += $(HALFSIPHASH_SATS)
nobase_nodist_pkginclude_HEADERS += $(HALFSIPHASH_DATS)
nobase_nodist_pkginclude_HEADERS += $(KEY_SATS)

#
# The following probably should not be installed.
#
#nobase_nodist_pkginclude_HEADERS += $(KEY_DATS)
#nobase_nodist_pkginclude_HEADERS += $(ATOMIC_SATS)
#nobase_nodist_pkginclude_HEADERS += $(ATOMIC_DATS)

#--------------------------------------------------------------------------
#
# The C library.
#

lib_LTLIBRARIES += libsiphash.la

SIPHASH_C_DATS = siphash/DATS/siphash_c.dats
SIPHASH_C_DATS_C = siphash/DATS/siphash_c_dats.c
EXTRA_DIST += $(SIPHASH_C_DATS)
CLEANFILES += $(SIPHASH_C_DATS_C)

HALFSIPHASH_C_DATS = siphash/DATS/halfsiphash_c.dats
HALFSIPHASH_C_DATS_C = siphash/DATS/halfsiphash_c_dats.c
EXTRA_DIST += $(HALFSIPHASH_C_DATS)
CLEANFILES += $(HALFSIPHASH_C_DATS_C)

libsiphash_la_SOURCES =
libsiphash_la_SOURCES += $(SIPHASH_C_DATS_C)
libsiphash_la_SOURCES += $(HALFSIPHASH_C_DATS_C)
libsiphash_la_SOURCES += siphash/siphash.h
libsiphash_la_SOURCES += siphash/halfsiphash.h

libsiphash_la_LIBADD =
libsiphash_la_LIBADD += libats2-siphash.la

nobase_nodist_pkginclude_HEADERS += $(SIPHASH_C_DATS)
nobase_nodist_pkginclude_HEADERS += $(HALFSIPHASH_C_DATS)
nobase_nodist_pkginclude_HEADERS += siphash/siphash.h
nobase_nodist_pkginclude_HEADERS += siphash/halfsiphash.h

#--------------------------------------------------------------------------

pkgconfigdir = ${libdir}/pkgconfig
nodist_pkgconfig_DATA += ats2-siphash.pc
nodist_pkgconfig_DATA += siphash.pc

#--------------------------------------------------------------------------

AM_DEFAULT_SOURCE_EXT = _dats.c

TESTS =
TESTS += $(check_PROGRAMS)

DISTRIBUTED_ATS2_TESTS =

M4_GENERATED_ATS2_TESTS =
M4_GENERATED_ATS2_TESTS += tests/test-siphash-2-4-64
M4_GENERATED_ATS2_TESTS += tests/test-siphash-2-4-128
M4_GENERATED_ATS2_TESTS += tests/test-siphash-4-8-64
M4_GENERATED_ATS2_TESTS += tests/test-siphash-4-8-128
M4_GENERATED_ATS2_TESTS += tests/test-siphash-2-4-64-hats
M4_GENERATED_ATS2_TESTS += tests/test-siphash-4-8-64-hats
M4_GENERATED_ATS2_TESTS += tests/test-halfsiphash-2-4-32
M4_GENERATED_ATS2_TESTS += tests/test-halfsiphash-2-4-64
M4_GENERATED_ATS2_TESTS += tests/test-halfsiphash-4-8-32
M4_GENERATED_ATS2_TESTS += tests/test-halfsiphash-4-8-64
M4_GENERATED_ATS2_TESTS += tests/test-halfsiphash-2-4-32-hats
M4_GENERATED_ATS2_TESTS += tests/test-halfsiphash-4-8-32-hats
M4_GENERATED_ATS2_TESTS += tests/test-key

tests_test_siphash_2_4_64_SOURCES =
tests_test_siphash_2_4_64_SOURCES += tests/test-siphash-2-4-64_dats.c
tests_test_siphash_2_4_64_SOURCES += tests/vectors_sats.c
tests_test_siphash_2_4_64_SOURCES += tests/vectors-2-4_dats.c
tests_test_siphash_2_4_64_LDADD =
tests_test_siphash_2_4_64_LDADD += libats2-siphash.la
tests_test_siphash_2_4_64_DEPENDENCIES =
tests_test_siphash_2_4_64_DEPENDENCIES += tests/vectors-2-4.h
tests_test_siphash_2_4_64_DEPENDENCIES += siphash/SATS/array_prf.sats

tests_test_siphash_2_4_128_SOURCES =
tests_test_siphash_2_4_128_SOURCES += tests/test-siphash-2-4-128_dats.c
tests_test_siphash_2_4_128_SOURCES += tests/vectors_sats.c
tests_test_siphash_2_4_128_SOURCES += tests/vectors-2-4_dats.c
tests_test_siphash_2_4_128_LDADD =
tests_test_siphash_2_4_128_LDADD += libats2-siphash.la
tests_test_siphash_2_4_128_DEPENDENCIES =
tests_test_siphash_2_4_128_DEPENDENCIES += tests/vectors-2-4.h
tests_test_siphash_2_4_128_DEPENDENCIES += siphash/SATS/array_prf.sats

tests_test_siphash_4_8_64_SOURCES =
tests_test_siphash_4_8_64_SOURCES += tests/test-siphash-4-8-64_dats.c
tests_test_siphash_4_8_64_SOURCES += tests/vectors_sats.c
tests_test_siphash_4_8_64_SOURCES += tests/vectors-4-8_dats.c
tests_test_siphash_4_8_64_LDADD =
tests_test_siphash_4_8_64_LDADD += libats2-siphash.la
tests_test_siphash_4_8_64_DEPENDENCIES =
tests_test_siphash_4_8_64_DEPENDENCIES += tests/vectors-4-8.h
tests_test_siphash_4_8_64_DEPENDENCIES += siphash/SATS/array_prf.sats

tests_test_siphash_4_8_128_SOURCES =
tests_test_siphash_4_8_128_SOURCES += tests/test-siphash-4-8-128_dats.c
tests_test_siphash_4_8_128_SOURCES += tests/vectors_sats.c
tests_test_siphash_4_8_128_SOURCES += tests/vectors-4-8_dats.c
tests_test_siphash_4_8_128_LDADD =
tests_test_siphash_4_8_128_LDADD += libats2-siphash.la
tests_test_siphash_4_8_128_DEPENDENCIES =
tests_test_siphash_4_8_128_DEPENDENCIES += tests/vectors-4-8.h
tests_test_siphash_4_8_128_DEPENDENCIES += siphash/SATS/array_prf.sats

tests_test_siphash_2_4_64_hats_SOURCES =
tests_test_siphash_2_4_64_hats_SOURCES += tests/test-siphash-2-4-64-hats_dats.c
tests_test_siphash_2_4_64_hats_SOURCES += tests/vectors_sats.c
tests_test_siphash_2_4_64_hats_SOURCES += tests/vectors-2-4_dats.c
tests_test_siphash_2_4_64_hats_LDADD =
tests_test_siphash_2_4_64_hats_LDADD += libats2-siphash.la
tests_test_siphash_2_4_64_hats_DEPENDENCIES =
tests_test_siphash_2_4_64_hats_DEPENDENCIES += tests/vectors-2-4.h
tests_test_siphash_2_4_64_hats_DEPENDENCIES += siphash/SATS/array_prf.sats

tests_test_siphash_4_8_64_hats_SOURCES =
tests_test_siphash_4_8_64_hats_SOURCES += tests/test-siphash-4-8-64-hats_dats.c
tests_test_siphash_4_8_64_hats_SOURCES += tests/vectors_sats.c
tests_test_siphash_4_8_64_hats_SOURCES += tests/vectors-4-8_dats.c
tests_test_siphash_4_8_64_hats_LDADD =
tests_test_siphash_4_8_64_hats_LDADD += libats2-siphash.la
tests_test_siphash_4_8_64_hats_DEPENDENCIES =
tests_test_siphash_4_8_64_hats_DEPENDENCIES += tests/vectors-4-8.h
tests_test_siphash_4_8_64_hats_DEPENDENCIES += siphash/SATS/array_prf.sats

tests_test_halfsiphash_2_4_32_SOURCES =
tests_test_halfsiphash_2_4_32_SOURCES += tests/test-halfsiphash-2-4-32_dats.c
tests_test_halfsiphash_2_4_32_SOURCES += tests/vectors_sats.c
tests_test_halfsiphash_2_4_32_SOURCES += tests/vectors-2-4_dats.c
tests_test_halfsiphash_2_4_32_LDADD =
tests_test_halfsiphash_2_4_32_LDADD += libats2-siphash.la
tests_test_halfsiphash_2_4_32_DEPENDENCIES =
tests_test_halfsiphash_2_4_32_DEPENDENCIES += tests/vectors-2-4.h
tests_test_halfsiphash_2_4_32_DEPENDENCIES += siphash/SATS/array_prf.sats

tests_test_halfsiphash_2_4_64_SOURCES =
tests_test_halfsiphash_2_4_64_SOURCES += tests/test-halfsiphash-2-4-64_dats.c
tests_test_halfsiphash_2_4_64_SOURCES += tests/vectors_sats.c
tests_test_halfsiphash_2_4_64_SOURCES += tests/vectors-2-4_dats.c
tests_test_halfsiphash_2_4_64_LDADD =
tests_test_halfsiphash_2_4_64_LDADD += libats2-siphash.la
tests_test_halfsiphash_2_4_64_DEPENDENCIES =
tests_test_halfsiphash_2_4_64_DEPENDENCIES += tests/vectors-2-4.h
tests_test_halfsiphash_2_4_64_DEPENDENCIES += siphash/SATS/array_prf.sats

tests_test_halfsiphash_4_8_32_SOURCES =
tests_test_halfsiphash_4_8_32_SOURCES += tests/test-halfsiphash-4-8-32_dats.c
tests_test_halfsiphash_4_8_32_SOURCES += tests/vectors_sats.c
tests_test_halfsiphash_4_8_32_SOURCES += tests/vectors-4-8_dats.c
tests_test_halfsiphash_4_8_32_LDADD =
tests_test_halfsiphash_4_8_32_LDADD += libats2-siphash.la
tests_test_halfsiphash_4_8_32_DEPENDENCIES =
tests_test_halfsiphash_4_8_32_DEPENDENCIES += tests/vectors-4-8.h
tests_test_halfsiphash_4_8_32_DEPENDENCIES += siphash/SATS/array_prf.sats

tests_test_halfsiphash_4_8_64_SOURCES =
tests_test_halfsiphash_4_8_64_SOURCES += tests/test-halfsiphash-4-8-64_dats.c
tests_test_halfsiphash_4_8_64_SOURCES += tests/vectors_sats.c
tests_test_halfsiphash_4_8_64_SOURCES += tests/vectors-4-8_dats.c
tests_test_halfsiphash_4_8_64_LDADD =
tests_test_halfsiphash_4_8_64_LDADD += libats2-siphash.la
tests_test_halfsiphash_4_8_64_DEPENDENCIES =
tests_test_halfsiphash_4_8_64_DEPENDENCIES += tests/vectors-4-8.h
tests_test_halfsiphash_4_8_64_DEPENDENCIES += siphash/SATS/array_prf.sats

tests_test_halfsiphash_2_4_32_hats_SOURCES =
tests_test_halfsiphash_2_4_32_hats_SOURCES += tests/test-halfsiphash-2-4-32-hats_dats.c
tests_test_halfsiphash_2_4_32_hats_SOURCES += tests/vectors_sats.c
tests_test_halfsiphash_2_4_32_hats_SOURCES += tests/vectors-2-4_dats.c
tests_test_halfsiphash_2_4_32_hats_LDADD =
tests_test_halfsiphash_2_4_32_hats_LDADD += libats2-siphash.la
tests_test_halfsiphash_2_4_32_hats_DEPENDENCIES =
tests_test_halfsiphash_2_4_32_hats_DEPENDENCIES += tests/vectors-2-4.h
tests_test_halfsiphash_2_4_32_hats_DEPENDENCIES += siphash/SATS/array_prf.sats

tests_test_halfsiphash_4_8_32_hats_SOURCES =
tests_test_halfsiphash_4_8_32_hats_SOURCES += tests/test-halfsiphash-4-8-32-hats_dats.c
tests_test_halfsiphash_4_8_32_hats_SOURCES += tests/vectors_sats.c
tests_test_halfsiphash_4_8_32_hats_SOURCES += tests/vectors-4-8_dats.c
tests_test_halfsiphash_4_8_32_hats_LDADD =
tests_test_halfsiphash_4_8_32_hats_LDADD += libats2-siphash.la
tests_test_halfsiphash_4_8_32_hats_DEPENDENCIES =
tests_test_halfsiphash_4_8_32_hats_DEPENDENCIES += tests/vectors-4-8.h
tests_test_halfsiphash_4_8_32_hats_DEPENDENCIES += siphash/SATS/array_prf.sats

tests_test_key_SOURCES =
tests_test_key_SOURCES += tests/test-key_dats.c
tests_test_key_LDADD =
tests_test_key_LDADD += libats2-siphash.la
tests_test_key_DEPENDENCIES =

tests/vectors_sats.c: tests/vectors.sats
tests/vectors_dats.c: tests/vectors.dats tests/vectors.sats
EXTRA_DIST += tests/vectors.sats
EXTRA_DIST += tests/vectors-2-4.dats
EXTRA_DIST += tests/vectors-4-8.dats
CLEANFILES += tests/vectors_sats.c
CLEANFILES += tests/vectors-2-4_dats.c
CLEANFILES += tests/vectors-4-8_dats.c

DISTRIBUTED_C_TESTS =

M4_GENERATED_C_TESTS =
M4_GENERATED_C_TESTS += tests/test-siphash-2-4-64-C
M4_GENERATED_C_TESTS += tests/test-siphash-2-4-128-C
M4_GENERATED_C_TESTS += tests/test-siphash-4-8-64-C
M4_GENERATED_C_TESTS += tests/test-siphash-4-8-128-C
M4_GENERATED_C_TESTS += tests/test-halfsiphash-2-4-32-C
M4_GENERATED_C_TESTS += tests/test-halfsiphash-2-4-64-C
M4_GENERATED_C_TESTS += tests/test-halfsiphash-4-8-32-C
M4_GENERATED_C_TESTS += tests/test-halfsiphash-4-8-64-C

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

tests_test_siphash_4_8_64_C_SOURCES =
tests_test_siphash_4_8_64_C_SOURCES += tests/test-siphash-4-8-64-C.c
tests_test_siphash_4_8_64_C_SOURCES += tests/vectors-4-8.h
tests_test_siphash_4_8_64_C_LDADD =
tests_test_siphash_4_8_64_C_LDADD += libsiphash.la

tests_test_siphash_4_8_128_C_SOURCES =
tests_test_siphash_4_8_128_C_SOURCES += tests/test-siphash-4-8-128-C.c
tests_test_siphash_4_8_128_C_SOURCES += tests/vectors-4-8.h
tests_test_siphash_4_8_128_C_LDADD =
tests_test_siphash_4_8_128_C_LDADD += libsiphash.la

tests_test_halfsiphash_2_4_32_C_SOURCES =
tests_test_halfsiphash_2_4_32_C_SOURCES += tests/test-halfsiphash-2-4-32-C.c
tests_test_halfsiphash_2_4_32_C_SOURCES += tests/vectors-2-4.h
tests_test_halfsiphash_2_4_32_C_LDADD =
tests_test_halfsiphash_2_4_32_C_LDADD += libsiphash.la

tests_test_halfsiphash_2_4_64_C_SOURCES =
tests_test_halfsiphash_2_4_64_C_SOURCES += tests/test-halfsiphash-2-4-64-C.c
tests_test_halfsiphash_2_4_64_C_SOURCES += tests/vectors-2-4.h
tests_test_halfsiphash_2_4_64_C_LDADD =
tests_test_halfsiphash_2_4_64_C_LDADD += libsiphash.la

tests_test_halfsiphash_4_8_32_C_SOURCES =
tests_test_halfsiphash_4_8_32_C_SOURCES += tests/test-halfsiphash-4-8-32-C.c
tests_test_halfsiphash_4_8_32_C_SOURCES += tests/vectors-4-8.h
tests_test_halfsiphash_4_8_32_C_LDADD =
tests_test_halfsiphash_4_8_32_C_LDADD += libsiphash.la

tests_test_halfsiphash_4_8_64_C_SOURCES =
tests_test_halfsiphash_4_8_64_C_SOURCES += tests/test-halfsiphash-4-8-64-C.c
tests_test_halfsiphash_4_8_64_C_SOURCES += tests/vectors-4-8.h
tests_test_halfsiphash_4_8_64_C_LDADD =
tests_test_halfsiphash_4_8_64_C_LDADD += libsiphash.la

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
