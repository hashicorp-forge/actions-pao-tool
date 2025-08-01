#!/usr/bin/env bats

# Need 1.7.0 for run() to accept flags
# Note: need 1.7.0 for bats_require_minimum_version definition.
bats_require_minimum_version 1.7.0

# Rename bats' `run` function as `bats_run`.
# This must be in the current shell, so it cannot be within a bats setup* function.
eval "$(echo -n 'bats_run()' ; declare -f run | tail -n +2)"

setup() {
    bats_load_library bats-support
    bats_load_library bats-assert

    source scripts/rename-by-part-number.sh
    export GITHUB_OUTPUT=/dev/null
}

@test "happy-path" {
    tempdir="$(mktemp -d)"
    bats_run --separate-stderr -- main "$BATS_TEST_DIRNAME/testdata/pao-metadata-files/happy-path" \
        "$BATS_TEST_DIRNAME/testdata/input-happy-path" \
        "$tempdir" 
    assert_equal "$stderr" ""
    assert [ -f "$tempdir/MOOCOWA.zip" ]
    assert [ -f "$tempdir/MOOCOWB.zip" ]
    assert [ -f "$tempdir/MOOCOWC.pdf" ]
    assert_success
}

@test "multiple eboms" {
    tempdir="$(mktemp -d)"
    bats_run --separate-stderr -- main "$BATS_TEST_DIRNAME/testdata/pao-metadata-files/multiple-eboms" \
        "$BATS_TEST_DIRNAME/testdata/input-happy-path" \
        "$tempdir" 
    assert_equal "$stderr" ""
    assert [ -f "$tempdir/MOOCOWA.zip" ]
    assert [ -f "$tempdir/MOOCOWB.zip" ]
    assert [ -f "$tempdir/MOOCOW1.zip" ]
    assert [ -f "$tempdir/MOOCOW2.zip" ]
    assert_success
}
