#!/usr/bin/env bash

set -euo pipefail

# MAX_LENGTH is the maximum length of the file name allowed by Tequila, including any extension.
# Over-length names yield errors.
readonly MAX_LENGTH=40

xlate() {
    local name="$1" repl=""
    repl="$name"

    # transformations
    repl="${repl/+ent}"
    repl="${repl/ubi-hsm/ubi}" # -hsm in docker image name is redundant
    repl="${repl/.hsm/_H}" # separator included here because hsm is consistently placed before FIPS; but this is brittle
    repl="${repl/.fips1402/_F2}"
    repl="${repl/H_F2/HF2}" # for hsm+fips remove the separator between them
    repl="${repl/-hsm/-H}" # hsm for linux packages
    repl="${repl/-fips1402/-F2}" # fips1402 for linux packages
    repl="${repl/-H-F2/-HF2}" # hsm+fips for linux packages
    repl="${repl/.fips1403/_F3}"
    repl="${repl/H_F3/HF3}" # for hsm+fips remove the separator between them
    repl="${repl/-fips1403/-F3}" # fips1403 for linux packages
    repl="${repl/-H-F3/-HF3}" # hsm+fips for linux packages
    repl="${repl/terraform-enterprise/tfe}"
    repl="${repl/crt-core-}" # strip crt-core- prefix for testing with helloworld
    repl="${repl/_production_/_}" # TFE puts 'production' in tarball names -- remove to shorten the name
    repl="${repl/-enterprise}" # consul-enterprise -> consul
    repl="${repl/[-_]release[-_]/_}" # nomad docker images have 'release' in their names
    repl="${repl/[-_]default[-_]/_}" # consul and vault docker images have 'default' in their names
    repl="${repl/[-_]fips[-_]/_}" # fips word is redundant
    repl="${repl/docker.}" # remove 'docker', it's redundant with '.tar'
    repl="${repl/redhat.}" # remove 'redhat', it's irrelevant for PAO
    # do this late to ensure it doesn't match `-fips1402` that should be handled by rules above
    repl="${repl/-fips}" # some artifacts have -fips in addition to .fips1402
    # regexps to strip checksums
    repl="$(sed -r -e 's,-[0-9a-fA-F]{7}_,_,' <<<"$repl")" # short hash ~ git abbreviated commit
    repl="$(sed -r -e 's,_[0-9a-fA-F]{40},,' <<<"$repl")"  # full SHA1 hash (in hex)

    # fix-ups
    # remove redundant _H
    case "$repl" in
        *-H_*_H*.rpm|*-H_*_H*.deb)
            repl="${repl/_HF2}"
            repl="${repl/_HF3}"
            repl="${repl/_H}"
            ;;
    esac

    # Remove PAO target from docker images
    case "$repl" in
        *_release-ibm-pao_*.tar)
            repl="${repl/release-ibm-pao_}"
            ;;
    esac

    # move F2 embedded in version string to be a suffix of the product name (preceding the version string)
    case "$repl" in
        *_F2-*.rpm)
            repl="${repl%%-*}-F2-${repl#*-}"
            repl="${repl/_F2-/-}"
            ;;
        *-F2-*.rpm)
            repl="${repl%%-*}-F2-${repl#*-}"
            repl="${repl/-F2-/-}"
            ;;
        *_F2-*.deb)
            repl="${repl%%_*}-F2_${repl#*_}"
            repl="${repl/_F2-/-}"
            ;;
        *_F3-*.rpm)
            repl="${repl%%-*}-F3-${repl#*-}"
            repl="${repl/_F3-/-}"
            ;;
        *-F3-*.rpm)
            repl="${repl%%-*}-F3-${repl#*-}"
            repl="${repl/-F3-/-}"
            ;;
        *_F3-*.deb)
            repl="${repl%%_*}-F3_${repl#*_}"
            repl="${repl/_F3-/-}"
            ;;
    esac

    # .sig files are allowed to exceed MAX_LENGTH because they are not uploaded to PAO
    if [[ ! "$repl" =~ \.(sig)$ ]] && [ "${#repl}" -gt $MAX_LENGTH ]; then
        echo "${repl}: translated name is ${#repl} characters, maximum allowed is ${MAX_LENGTH}." 1>&2
        return 1
    fi

    echo "$repl"
}

main() {
    xlate "$@"
}

if [[ "${BASH_SOURCE[0]}" == "${0}" ]]; then
    main "$@"
fi
