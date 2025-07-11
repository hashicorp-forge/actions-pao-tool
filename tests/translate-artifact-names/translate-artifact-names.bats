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

    source scripts/translate-artifact-names
}

@test "setup happy path" {
    local IN_DIR="${BATS_TEST_DIRNAME}/testdata/input/happy-path"
    local OUT_DIR="${BATS_TEST_DIRNAME}/testdata/output/happy-path"

    bats_run -- prepare "$IN_DIR" "$OUT_DIR"
    assert_output "" # no output on success
    assert_success
}

@test "setup create out-dir" {
    local IN_DIR="${BATS_TEST_DIRNAME}/testdata/input/happy-path"
    local OUT_DIR="${BATS_TEST_DIRNAME}/testdata/output/create-out-dir"

    # if the dir to create exists from previous runs, remove it
    rm -rf "$OUT_DIR"

    bats_run -- prepare "$IN_DIR" "$OUT_DIR"
    assert_output "" # no output on success
    assert_success
}

@test "setup no input dir" {
    bats_run -- prepare
    assert_output --partial "No input"
    assert_failure
}

@test "setup no output dir" {
    bats_run -- prepare "placeholder"
    assert_output --partial "No output"
    assert_failure
}

@test "setup both dirs invalid" {
    local IN_DIR="${BATS_TEST_DIRNAME}/testdata/input/no-such-path"
    local OUT_DIR="/root/bats/should-be-unwritable" # assume /root is unwritable to this process

    bats_run -- prepare "$IN_DIR" "$OUT_DIR"
    assert_output --partial "input directory does not exist"
    assert_output --partial "could not be created"
    assert_failure
}

@test "main happy path" {
    local IN_DIR="${BATS_TEST_DIRNAME}/testdata/input/happy-path"
    local OUT_DIR="${BATS_TEST_DIRNAME}/testdata/output/create-out-dir"
    local input_count=0 output_count=0

    # if the dir to create exists from previous runs, remove it
    rm -rf "$OUT_DIR"

    input_count="$(ls -1 "$IN_DIR" | wc -l | xargs)"

    bats_run -- main "$IN_DIR" "$OUT_DIR"
    output_count="$(ls -1 "$OUT_DIR" | wc -l | xargs)"
    assert_equal "$output_count" "$input_count"
    assert_success
}

@test "main no artifacts" {
    local IN_DIR="${BATS_TEST_DIRNAME}/testdata/input/empty"
    local OUT_DIR="${BATS_TEST_DIRNAME}/testdata/output/unused"
    local input_count=0 output_count=0

    # if the dir to create exists from previous runs, remove it
    rm -rf "$OUT_DIR"

    input_count="$(ls -1 "$IN_DIR" | wc -l | xargs)"
    assert_equal "$input_count" 0

    bats_run -- main "$IN_DIR" "$OUT_DIR"
    output_count="$(ls -1 "$OUT_DIR" | wc -l | xargs)"
    assert_equal "$output_count" "$input_count"
    assert_output --partial "No artifacts translated"
    assert_failure
}
