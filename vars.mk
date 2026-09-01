#
# Directories
# Set these explicitly, they can be overriden from mbconfig
#
OBJDIR:= ${PROJDIR}/build
INCDIR:= ${PROJDIR}/include
MBDIR:= ${.PARSEDIR}

.if exists(${PROJDIR}/mbconfig.mk)
.  include "${PROJDIR}/mbconfig.mk"
.endif

#
# Toolchain
#
CC?= cc
AS?= as
LD?= ld
AR?= ar
NM?= nm
STRIP?= strip
RANLIB?= ranlib
READELF?= readelf
OBJDUMP?= objdump
OBJCOPY?= objcopy

#
# In case of compiling main code for a different arch / target and
#   needing to compile host utilities.
#
HOSTCC?= ${CC}
HOSTAS?= ${AS}
HOSTLD?= ${LD}
HOSTAR?= ${AR}
HOSTNM?= ${NM}
HOSTSTRIP?= ${STRIP}
HOSTRANLIB?= ${RANLIB}
HOSTREADELF?= ${READELF}
HOSTOBJDUMP?= ${OBJDUMP}
HOSTOBJCOPY?= ${OBJCOPY}

#
# Toolchain flags
#
CFLAGS?= -I${INCDIR}
ASFLAGS?=
CASFLAGS?= -I${INCDIR}
LDFLAGS?= -s

HOSTCFLAGS?= ${CFLAGS}
HOSTASFLAGS?= ${ASFLAGS}
HOSTCASFLAGS?= ${CASFLAGS}
HOSTLDFLAGS?= ${LDFLAGS}

.if defined(DEBUG) && ${DEBUG} == 1
CFLAGS+= -DDEBUG
CASFLAGS+= -DDEBUG

HOSTCFLAGS+= -DDEBUG
HOSTCASFLAGS+= -DDEBUG
.endif
