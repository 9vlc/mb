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

.for _subdir in ${SUBDIRS}
SUBDIR:= ${.INCLUDEDFROMDIR}/${_subdir}
SUBOBJDIR:= ${OBJDIR}/${_subdir}
SUBDIR.${_subdir}:= ${SUBDIR}
SUBOBJDIR.${_subdir}:= ${SUBOBJDIR}

.  include "${.INCLUDEDFROMDIR}/${_subdir}/sub.mk"
.endfor

SUBDIRS:=
