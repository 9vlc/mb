#
# Prepare variables and include sub.mk from subdirectories
# To be included from src/dirs.mk or whatever else
#
# Input vars:
#   SUBDIRS - List of subdirectories
#
# Output vars:
#   SUBDIR - Volatile path to the source subdirectory
#   SUBOBJDIR - Volatile path to object subdirectory
#   SUBDIR.name - Path to source subdirectory
#   SUBOBJDIR.name - Path to object subdirectory
#

_i.indirs:= ${.INCLUDEDFROMDIR}

.for _subdir.indirs in ${SUBDIRS}
SUBDIR:= ${_i.indirs}/${_subdir.indirs}
SUBOBJDIR:= ${OBJDIR}/${_subdir.indirs}
SUBDIR.${_subdir.indirs}:= ${SUBDIR}
SUBOBJDIR.${_subdir.indirs}:= ${SUBOBJDIR}

.  include "${_i.indirs}/${_subdir.indirs}/sub.mk"
.endfor

SUBDIRS:=
