#
# Compile object files from EXTRAS for manual build targets
#
# Input vars:
#   EXTRAS - List of additional output objects
#
# Output vars:
#   EXTRAS.name - Labeled EXTRAS
#   EXTRAS_ALL - All EXTRAS in the project at this point, take same care
#                  as with OBJS_ALL
#
# If an object file starts with @, it will be assumed it's outputted to
#   the root of OBJDIR and not SUBOBJDIR
#

_i:= ${.INCLUDEDFROMDIR}
_es:= ${EXTRAS}
EXTRAS:=

.for _ex in ${_es}
_p:= ${_ex:C/^(.).*/\1/}

.  if ${_p} == "@"
EXTRAS:= ${EXTRAS} ${OBJDIR}/${_ex:C/^.//}
.  else
EXTRAS:= ${EXTRAS} ${OBJDIR}/${_i:T}/${_ex}
.  endif

.endfor

EXTRAS_ALL:= ${EXTRAS_ALL} ${EXTRAS}
EXTRAS.${_i:T}:= ${EXTRAS}
EXTRAS:=
