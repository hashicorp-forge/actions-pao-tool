# source from bash script

log() { echo "$*" 1>&2 ; }

ERROR_COUNT=0
err() { log "[error] $*" ; ERROR_COUNT=$((ERROR_COUNT + 1)) ; }

die() { err "$*" ; exit 1 ; }
