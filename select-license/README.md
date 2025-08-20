# Select License

This action selects a license (directory name) based on a target architecture,
which should be `amd64`, `arm64`, `s390x`, etc. Some architectures require
specific licenses, e.g. `s390x` (`Z`). If a license directory is found matching
the architecture name, it will be used, otherwise `default` will be selected.

Note that s390x _always_ uses `s390x`, but the license documents are this architecture
are always different from the default.

Note for Terraform Enterprise: because TFE for Z is itself an amd64 image but can be
bundled with the Z license for use in managing s390x hosts, the architecture should
be set to s390x for that use case.

## Usage

### Example

```yaml
# ...
- uses: hashicorp-forge/actions-pao-tool/select-license@v1
  with:
    arch: ${{ matrix.arch }} # or perhaps ${{ inputs.goarch }}
# ...
```

### Inputs

| Name | Description             | Example |
| ---- | ----------------------- | ------- |
| arch | The target architecture | `amd64` |

### Outputs

| Name         | Description                       | Example                            |
| ------------ | --------------------------------- | ---------------------------------- |
| license_path | The path to the license documents | `.release/ibm-pao/license/default` |
