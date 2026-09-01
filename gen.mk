#
# Generate build directives for source files
#
# Input vars:
#   SRCS - List of source files in this subdirectory
#   HOSTBUILD - (0/1) Build using HOST* vars
#
# Output vars:
#   OBJS - Volatile list of object files for this subdirectory
#          Not persistent, only use in directive definitions and not shell
#   OBJS.name - List of object files for this subdirectory
#   OBJS_ALL - All object files in the project at this point, only use in the
#                last subdirectory or main Makefile
#
#   HOSTOBJS, HOSTOBJS.name, HOSTOBJS_ALL - Same as before, HOSTBUILD == 1
#
# If a source file name starts with @, its output object will be
#   located in OBJDIR instead of SUBOBJDIR
#

_i:= ${.INCLUDEDFROMDIR}
OBJS:=
HOSTOBJS:=

.if !defined(HOSTBUILD)
HOSTBUILD:= 0
.endif

.for _sf in ${SRCS}
_fl:= ${_sf:C/^(.).*/\1/}

# Different paths depending on if name starts with @
.  if ${_fl} == "@"
_rsf:= ${SUBDIR}/${_sf:C/^.//}
_o:= ${OBJDIR}/${_sf:R:C/^.//}.o
.  else
_rsf:= ${SUBDIR}/${_sf}
_o:= ${SUBOBJDIR}/${_sf:R}.o
.  endif

# The target and a following ifhell
${_o}: ${_rsf}
.  if ${HOSTBUILD} == 1
.    if ${_rsf:E} == "c"
	${HOSTCC} ${HOSTCFLAGS} -c -o $@ $>
.    elif ${_rsf:E} == "s"
	${HOSTAS} ${HOSTASFLAGS} -c -o $@ $>
.    elif ${_rsf:E} == "S"
	${HOSTCC} ${HOSTCASFLAGS} -c -o $@ $>
.    else
.      error "Unknown source file extension: ${_rsf:E}"
.    endif
.  else
.    if ${_rsf:E} == "c"
	${CC} ${CFLAGS} -c -o $@ $>
.    elif ${_rsf:E} == "s"
	${AS} ${ASFLAGS} -c -o $@ $>
.    elif ${_rsf:E} == "S"
	${CC} ${CASFLAGS} -c -o $@ $>
.    else
.      error "Unknown source file extension: ${_rsf:E}"
.    endif
.  endif

.  if ${HOSTBUILD} == 1
HOSTOBJS:= ${HOSTOBJS} ${_o}
.  else
OBJS:= ${OBJS} ${_o}
.  endif
.endfor

.if ${HOSTBUILD} == 1
HOSTOBJS_ALL:= ${HOSTOBJS_ALL} ${HOSTOBJS}
HOSTOBJS.${_i:T}:= ${HOSTOBJS}
.else
OBJS_ALL:= ${OBJS_ALL} ${OBJS}
OBJS.${_i:T}:= ${OBJS}
.endif

SRCS:=
HOSTBUILD:= 0
