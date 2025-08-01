#!/usr/bin/env bash

log() { echo "$*" 1>&2 ; }

ERROR_COUNT=0
ERROR_TOTAL=0
err() { log "[error] $*" ; ERROR_COUNT=$((ERROR_COUNT + 1)) ; }

rename_by_part_number() { local pao_dir="$1" input_dir="$2" output_dir="$3" 

    if ! [[ -e "$pao_dir" ]]; then
        err "PAO directory '$pao_dir' does not exist"
        return $ERROR_COUNT
    fi

    if ! [[ -e "$input_dir" ]]; then
        err "Input directory '$input_dir' does not exist"
        return $ERROR_COUNT
    fi

    if ! [[ -e "$output_dir" ]]; then
        err "Output directory '$output_dir' does not exist"
        return $ERROR_COUNT
    fi

    for ebom in "$pao_dir/v1/eboms/"*.csv; do
        echo "Processing ebom: $ebom"
        "${BASH_SOURCE%/*}/verify-required-files.sh" get-part-map "$ebom" > part-map.csv

        # Link the files to their new filenames
        while IFS=, read -r part_number filename; do
            if [[ -z "$part_number" || -z "$filename" ]]; then
                err "Part number or filename was empty - part number: '$part_number', filename: '$filename'"
                continue
            fi

            filesource_dir=$input_dir

            if [[ "$filename" == "Getting Started"* ]]; then
                # This is a Getting Started guide, which comes from the PAO metadata
                filesource_dir="$pao_dir"/v1
            fi

            extension="${filename##*.}"
            if ! [ -f "$filesource_dir/$filename" ]; then
                err "File '$filename' does not exist in directory $filesource_dir"
                continue
            fi

            if ! ln -v "$filesource_dir/$filename" "$output_dir/$part_number.$extension"; then
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
