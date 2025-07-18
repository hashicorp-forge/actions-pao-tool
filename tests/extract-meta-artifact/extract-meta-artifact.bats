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
    bats_load_library bats-file

    source "${BATS_TEST_DIRNAME}/../../scripts/extract-meta-artifact"
    export TESTDATA="${BATS_TEST_DIRNAME}/testdata"
}

@test "validate_input happy path" {
    bats_run -- validate_input "${TESTDATA}/crt-pao-meta.zip" "${TESTDATA}/output"
    assert_success
}

@test "validate_input no archive" {
    bats_run -- validate_input "" "${TESTDATA}/output"
    assert_failure
}

@test "validate_input no out_dir" {
    bats_run -- validate_input "${TESTDATA}/crt-pao-meta.zip" ""
    assert_failure
}

@test "validate_contents happy path" {
    bats_run -- validate_contents "${TESTDATA}/tree-happy-path"
    assert_success
}

@test "validate_contents no v1" {
    bats_run -- validate_contents "${TESTDATA}/empty"
    assert_output --partial "No v1/ directory"
    assert_failure
}

@test "validate_contents no pdf" {
    bats_run -- validate_contents "${TESTDATA}/tree-no-pdf"
    assert_output --partial "No PDF documents found"
    assert_failure
}

@test "validate_contents no csv" {
    bats_run -- validate_contents "${TESTDATA}/tree-no-eboms"
    assert_output --partial "No CSV documents found"
    assert_failure
}

@test "main happy path" {
    OUT_DIR="${TESTDATA}/output/main-happy-path"
    rm -rf "$OUT_DIR"
    bats_run -- main "${TESTDATA}/crt-pao-meta.zip" "$OUT_DIR"

    assert_dir_exists "$OUT_DIR"
    assert_dir_exists "$OUT_DIR/v1"
    assert_dir_exists "$OUT_DIR/v1/eboms"
    assert_file_exists "$OUT_DIR/v1/Getting Started with mooing cows.pdf"
    assert_file_exists "$OUT_DIR/v1/eboms/jersey.premium.csv"
    assert_success
}
