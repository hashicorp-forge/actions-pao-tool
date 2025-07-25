# Collect

The `collect` action creates a zip archive holding assorted files required for PAO releases:
* getting started guide(s)
* eBOM(s)
* etc.

This archive is passed through the release stages to ensure the files are available for processing and validation,
but it is not, itself, a release artifact.
This action should be called from the build workflow
for a product releasing to PAO.

Note that the action uploads the zip artifact,
no additional upload step is required.

There is a corresponding extraction action, [extract-meta-artifact](../extract-meta-artifact).

## Usage

### Example

```yaml
steps:
    # ...
    - uses: actions/checkout@latest
    - uses: hashicorp-forge/actions-pao-tool/collect@v1
```

### Inputs

This action does not accept input parameters.

### Outputs

| Name | Description | Example |
| - | - | - |
| archive | The newly created zip archive | `/tmp/tmp.fqLgZgCpCM/crt-pao-meta.zip` |
