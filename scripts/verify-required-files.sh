#!/usr/bin/env bash

log() { echo "$*" 1>&2 ; }

ERROR_COUNT=0
err() { log "[error] $*" ; ERROR_COUNT=$((ERROR_COUNT + 1)) ; }

req_files() { local PAO_ZIP="$1"
    if [[ ! -f "$PAO_ZIP" ]]; then
        err "IBM PAO zip artifact '$PAO_ZIP' not found."
        return $ERROR_COUNT
    fi

    PAO_ZIPINFO=$(zipinfo -1 "$PAO_ZIP")

    for pattern in 'Getting Started.*\.pdf' 'eboms/.*\.csv'; do
        if !  grep -e "$pattern" <<< "$PAO_ZIPINFO" > /dev/null; then
          err "File name matching pattern '$pattern' not found in IBM PAO zip artifact."
        fi
    done

    return $ERROR_COUNT
}

# Example of final map (still in CSV)
# M0RKZML,nomad_1.10.1_linux_s390x.zip
# M0RL0ML,nomad-1.10.1-1.s390x.rpm
# M0RL1ML,nomad_1.10.1-1_s390x.deb
# M0RL2ML,Getting Started with IBM Nomad for Z.pdf
extract_part_map() { local file_path="$1"
    local -r col_partno=3 col_fname=12 # column indices for part number and customer file name

    local entries

    # Extract the portion of the CSV holding the parts and file names:
    #  * csvcut to extract columns
    #  * sed to remove lines before the portion and those after the portion
    #    note: sed address ranges are inclusive, so this removes the header and blank rows that bound the entries we want.
    entries="$( csvcut -c "${col_partno}-${col_fname}" < "$file_path" | sed '1,/Customer file name/ d ; /,,,,,,,,,/,$ d' )"

    # Extract the part numbers and file names.  Also remove blank lines because
    # some eBOMs have empty rows in the middle, e.g. between the last build
    # artifact and the Getting Started guide.
    # Note: the target column numbers have shifted by 2 because the previous csvcut removed columns 1-2.
    entries="$( csvcut -x -c $((col_partno - 2)),$((col_fname - 2)) <<<"$entries" )"
    printf "%s\n" "$entries"
}

# Returns the short name for a product based on its long name.
# Most products will not have a special short name, 
# so the default is to return the input
product_to_short_name() {
  case "$1" in
    crt-core-helloworld) echo "helloworld" ;;
    # add more mappings here; 
    # the translate-artifact-names.sh script produces the short names
    # and will need replacement rules that produce the same short names
    *) echo "$1" ;;  # default: return input if no mapping
  esac
}

ck_has_name_version() { local map="$1" product="$2" version="$3"
    local ERROR_COUNT=0
    local parts

    product=$(product_to_short_name "$product")

    # Extract file names
    # example:
    # nomad_1.10.1_linux_s390x.zip
    # nomad-1.10.1-1.s390x.rpm
    # nomad_1.10.1-1_s390x.deb
    # Getting Started with IBM Nomad for Z.pdf
    parts="$( csvcut -c 2 <<<"$map" )"

    # Products with a long name may have a short name version
    # This avoids overly long filenames for IBM's systems
    # if [[ -v product_to_short_name_map["$product"] ]]; then
    #     product="${product_to_short_name_map[$product]}"
    # fi

    while read -r fname ; do
        if grep "$product" <<<"$fname" >/dev/null && grep -F "$version" <<<"$fname" >/dev/null ; then
            # found a match, test passed
            return 0
        fi
    done <<<"$parts"

    err "No filename in parts list includes both '$product' and '$version'."
    return $ERROR_COUNT
}

# All part numbers must match the format.
# All part numbers must be unique.
ck_part_numbers() { local map="$1"
    local ERROR_COUNT=0
    local -r pattern_partno='^[A-Z0-9]{7}$'

    local parts
    parts="$( csvcut -c 1 <<<"$map" | sort | uniq -c )"
    # example list with duplicates counted by uniq:
    # 2      M0RKZML
    # 1      M0RL0ML
    # 2      M0RL1ML
    # 1      M0RL2ML

    local pno count
    while read -r count pno ; do
        if [ "$count" -gt 1 ]; then
            err "${pno}: part number duplicated"
        fi

        if ! grep -E "$pattern_partno" <<< "$pno" >/dev/null ; then
            err "${pno}: invalid part number: does not match '$pattern_partno'."
        fi
    done <<<"$parts"

    return $ERROR_COUNT
}

ck_has_guide() { local map="$1"
    local ERROR_COUNT=0
    local parts

    # Extract file names
    # example:
    # nomad_1.10.1_linux_s390x.zip
    # Getting Started with IBM Nomad for Z.pdf
    parts="$( csvcut -c 2 <<<"$map" )"
    while read -r fname ; do
        if grep "Getting Started" <<<"$fname" >/dev/null ; then
            # found a match, test passed
            return 0
        fi
    done <<<"$parts"

    err "No Getting Started guide found."
    return $ERROR_COUNT
}

check_ebom_parts() { local file_path="$1" product="$2" version="$3"
    local part_map_entries
    part_map_entries="$( extract_part_map "$file_path" )"
    ck_has_name_version "$part_map_entries" "$product" "$version"
    ck_part_numbers "$part_map_entries"
    ck_has_guide "$part_map_entries"

# number of artifacts must match number of rows

}

main() {
    set -euo pipefail
    case "$1" in
        req-files)
            shift
            req_files "$@"
            ;;
        check-ebom-parts)
            shift
            check_ebom_parts "$@"
            ;;
        get-part-map)
            shift
            extract_part_map "$@" 
            ;;
        *)
            err "Unknown command: $1"
            return 1
            ;;
    esac
}

if [[ "${BASH_SOURCE[0]}" == "${0}" ]]; then
    main "$@"
fi
