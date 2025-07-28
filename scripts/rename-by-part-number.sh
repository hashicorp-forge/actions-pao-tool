#!/usr/bin/env bash

log() { echo "$*" 1>&2 ; }

ERROR_COUNT=0
ERROR_TOTAL=0
err() { log "[error] $*" ; ERROR_COUNT=$((ERROR_COUNT + 1)) ; }

rename_by_part_number() { local pao_dir="$1" input_dir="$2" output_dir="$3" 

    for ebom in "$pao_dir/v1/eboms/"*.csv; do
        echo "Processing ebom: $ebom"
        "${BASH_SOURCE%/*}/verify-required-files.sh" get-part-map "$ebom" > part-map.csv

        # Link the files to their new filenames
        while IFS=, read -r part_number filename; do
            if [[ -z "$part_number" || -z "$filename" ]]; then
                err "Part number or filename was empty - part number: '$part_number', filename: '$filename'"
                continue
            fi

            extension="${filename##*.}"
            if ! [ -f "$input_dir/$filename" ]; then
                err "File '$filename' does not exist in input directory"
                continue
            fi

            if ! ln -v "$input_dir/$filename" "$output_dir/$part_number.$extension"; then
                err "Duplicate part number '$part_number' for file '$filename'."
                continue
            fi
        done < "part-map.csv"

        if [[ $ERROR_COUNT -gt 0 ]]; then
            err "Encountered $ERROR_COUNT errors while processing part numbers for ebom '$ebom'."
            ERROR_TOTAL=$((ERROR_TOTAL + ERROR_COUNT))
            ERROR_COUNT=0
        fi
    done

    if [[ $ERROR_TOTAL -gt 0 ]]; then
        exit 1
    fi
}

main() {
    set -euo pipefail
    rename_by_part_number "$@"
}

if [[ "${BASH_SOURCE[0]}" == "${0}" ]]; then
    main "$@"
fi
