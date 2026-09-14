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

_i.extras:= ${.INCLUDEDFROMDIR}
_es.extras:= ${EXTRAS}
EXTRAS:=

.for _ex.extras in ${_es.extras}
_p.extras:= ${_ex.extras:C/^(.).*/\1/}

.  if ${_p.extras} == "@"
EXTRAS:= ${EXTRAS} ${OBJDIR}/${_ex.extras:C/^.//}
.  else
EXTRAS:= ${EXTRAS} ${OBJDIR}/${_i.extras:T}/${_ex.extras}
.  endif

.endfor

EXTRAS_ALL:= ${EXTRAS_ALL} ${EXTRAS}
EXTRAS.${_i.extras:T}:= ${EXTRAS}
EXTRAS:=
