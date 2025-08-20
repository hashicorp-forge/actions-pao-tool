#!/usr/bin/env bats

bats_require_minimum_version 1.9.0

# Rename bats' `run` function as `bats_run`.
# This must be in the current shell, so it cannot be within a bats setup* function.
eval "$(echo -n 'bats_run()' ; declare -f run | tail -n +2)"

# Dump env before each test
setup() {
    bats_load_library bats-support
    bats_load_library bats-assert

    export GITHUB_OUTPUT=/dev/null
    source "${BATS_TEST_DIRNAME}/../../scripts/select-license"
}

@test "happy-path amd64" {
    local ARCH=amd64 DIR="${BATS_TEST_DIRNAME}/testdata/happy-path/.release/ibm-pao/license"
    bats_run -- main "$ARCH" "$DIR"
    assert_line "${DIR}/default"
    refute_line --partial '[error]'
    assert_success
}

@test "happy-path s390x" {
    local ARCH=s390x DIR="${BATS_TEST_DIRNAME}/testdata/happy-path/.release/ibm-pao/license"
    bats_run -- main "$ARCH" "$DIR"
    assert_line "${DIR}/s390x"
    refute_line --partial '[error]'
    assert_success
}

@test "happy-path amd64 default path" {
    local ARCH=amd64
    # override default to dir existence test can pass
    local DEFAULT_LICENSE_BASE_DIR="${BATS_TEST_DIRNAME}/testdata/happy-path/.release/ibm-pao/license"
    bats_run -- main "$ARCH" # no DIR parameter for default path
    assert_line "${DEFAULT_LICENSE_BASE_DIR}/default"
    refute_line --partial '[error]'
    assert_success
}

@test "no-arch" {
    bats_run -- main
    assert_line --partial 'No architecture specified.'
    assert_failure
}

@test "missing path" {
    bats_run -- main fake_arch /path/to/non-existent/dir
    assert_line --partial 'directory missing'
    assert_failure
}

@test "s390x missing license" {
    local ARCH=s390x DIR="${BATS_TEST_DIRNAME}/testdata/missing-s390x/.release/ibm-pao/license"
    bats_run -- main "$ARCH" "$DIR"
    assert_line --partial 'directory missing'
    assert_failure
}
