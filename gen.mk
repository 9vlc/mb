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

_i.gen:= ${.INCLUDEDFROMDIR}
OBJS:=
HOSTOBJS:=

.if !defined(HOSTBUILD)
HOSTBUILD:= 0
.endif

.for _sf.gen in ${SRCS}
_fl.gen:= ${_sf.gen:C/^(.).*/\1/}

# Different paths depending on if name starts with @
.  if ${_fl.gen} == "@"
_rsf.gen:= ${SUBDIR}/${_sf.gen:C/^.//}
_o.gen:= ${OBJDIR}/${_sf.gen:R:C/^.//}.o
.  else
_rsf.gen:= ${SUBDIR}/${_sf.gen}
_o.gen:= ${SUBOBJDIR}/${_sf.gen:R}.o
.  endif

# The target and a following ifhell
${_o.gen}: ${_rsf.gen}
.  if ${HOSTBUILD} == 1
.    if ${_rsf.gen:E} == "c"
	${HOSTCC} ${HOSTCFLAGS} -c -o $@ $>
.    elif ${_rsf.gen:E} == "s"
	${HOSTAS} ${HOSTASFLAGS} -c -o $@ $>
.    elif ${_rsf.gen:E} == "S"
	${HOSTCC} ${HOSTCASFLAGS} -c -o $@ $>
.    else
.      error "Unknown source file extension: ${_rsf.gen:E}"
.    endif
.  else
.    if ${_rsf.gen:E} == "c"
	${CC} ${CFLAGS} -c -o $@ $>
.    elif ${_rsf.gen:E} == "s"
	${AS} ${ASFLAGS} -c -o $@ $>
.    elif ${_rsf.gen:E} == "S"
	${CC} ${CASFLAGS} -c -o $@ $>
.    else
.      error "Unknown source file extension: ${_rsf.gen:E}"
.    endif
.  endif

.  if ${HOSTBUILD} == 1
HOSTOBJS:= ${HOSTOBJS} ${_o.gen}
.  else
OBJS:= ${OBJS} ${_o.gen}
.  endif
.endfor

.if ${HOSTBUILD} == 1
HOSTOBJS_ALL:= ${HOSTOBJS_ALL} ${HOSTOBJS}
HOSTOBJS.${_i.gen:T}:= ${HOSTOBJS}
.else
OBJS_ALL:= ${OBJS_ALL} ${OBJS}
OBJS.${_i.gen:T}:= ${OBJS}
.endif

SRCS:=
HOSTBUILD:= 0
