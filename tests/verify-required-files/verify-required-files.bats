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

    source scripts/verify-required-files.sh
    export GITHUB_OUTPUT=/dev/null
}

setup_file() {
    load testdata/constants
}

@test "ibm-pao_invalid-command" {
    bats_run --separate-stderr -- main moo-cow 
    assert_equal "$stderr" "[error] Unknown command: moo-cow"
    assert_failure
}

@test "req-files: ibm-pao happy-path" {
    bats_run --separate-stderr -- main req-files "$BATS_TEST_DIRNAME/testdata/happy-path-pao-meta.zip"
    assert_equal "$stderr" ""
    assert_success
}

@test "req-files: ibm-pao missing Getting Started file" {
    bats_run --separate-stderr -- req_files "$BATS_TEST_DIRNAME/testdata/no-getting-started-pao-meta.zip"
    echo "output: $output"
    assert_equal "$stderr" "[error] File name matching pattern 'Getting Started.*\.pdf' not found in IBM PAO zip artifact."
    assert_failure
}

@test "req-files: ibm-pao missing eBOM" {
    bats_run --separate-stderr -- req_files "$BATS_TEST_DIRNAME/testdata/no-ebom-pao-meta.zip"
    echo "output: $output"
    assert_equal "$stderr" "[error] File name matching pattern 'eboms/.*\.csv' not found in IBM PAO zip artifact."
    assert_failure
}

@test "extract-part-map 1" {
    bats_run extract_part_map "$BATS_TEST_DIRNAME/testdata/ebom.good.1.csv"
    assert_output "$PART_MAP_1"
    assert_success
}

@test "extract-part-map 2" {
    bats_run extract_part_map "$BATS_TEST_DIRNAME/testdata/ebom.good.2.csv"
    assert_output "$PART_MAP_2"
    assert_success
}

@test "part numbers: happy path" {
    run ck_part_numbers "$PART_MAP_2"
    refute_output --partial "part number duplicated"
    refute_output --partial "Invalid part number"
    assert_success
}

@test "part numbers: duplicate parts" {
    run ck_part_numbers "$PART_MAP_DUPLICATES"
    refute_output --partial "Invalid part number"
    assert_output --partial "part number duplicated"
    assert_failure
}

@test "part numbers: invalid part number" {
    run ck_part_numbers "$PART_MAP_INVALID_PARTS"
    refute_output --partial "part number duplicated"
    assert_output --partial "M: invalid part number"
    assert_output --partial "m0rl0ml: invalid part number"
    assert_output --partial "M0RL1ML0: invalid part number"
    assert_failure
}

@test "name and version: happy path" {
    run ck_has_name_version "$PART_MAP_1" "nomad" "1.10.1"
    assert_success
}

@test "name and version: no product name match" {
    # PART_MAP_1 is for nomad 1.10.1
    run ck_has_name_version "$PART_MAP_1" "consul" "1.10.1"
    assert_output --partial "No filename in parts list includes both"
    assert_failure
}

@test "name and version: no product version match" {
    # PART_MAP_1 is for nomad 1.10.1
    run ck_has_name_version "$PART_MAP_1" "nomad" "0.0.1"
    assert_output --partial "No filename in parts list includes both"
    assert_failure
}

@test "getting started guide: present" {
    run ck_has_guide "$PART_MAP_1"
    assert_success
}

@test "getting started guide: absent" {
    run ck_has_guide "$PART_MAP_NO_GUIDE"
    assert_output --partial "No Getting Started guide found."
    assert_failure
}

@test "check_ebom_parts: happy path" {
    run check_ebom_parts "$BATS_TEST_DIRNAME/testdata/ebom.good.1.csv" "nomad" "1.10.1"
    assert_success
}

@test "get-parts-map: ibm-pao happy-path" {
    bats_run --separate-stderr -- main get-part-map "$BATS_TEST_DIRNAME/testdata/ebom.good.1.csv"
    assert_equal "$stderr" ""
    assert_output "$PART_MAP_1"
    assert_success
}
