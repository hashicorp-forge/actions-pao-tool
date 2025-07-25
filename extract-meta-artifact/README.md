# Extract Metadata Artifact

This action extracts an archive previously created with the [collect](../collect) action.
Basic validation is performed before extraction by calling
`scripts/verify-required-files.sh req-files $ARCHIVE`,
which examines the archive but does not extract it to disk.

## Usage

### Example

```yaml
    # ...
    - name: Extract Metadata
      uses: hashicorp-forge/actions-pao-tool/extract-meta-artifact
      with:
        archive: path/to/crt-pao-meta.zip
        output-dir: path/to/meta-dir # optionally specify an output directory
    # ...
```

### Inputs

| Name | Description | Example |
| - | - | - |
| archive | The archive to extract | `./crt-pao-meta.zip` |
| output-dir | (optional) The directory in which to extract the archive.  When omitted, a temporary directory is created. | `./pao-meta/` |

### Outputs
| Name | Description | Example |
| - | - | - |
| output-dir | The directory where the archive was extracted.  If the output directory was specified as an input, this field will have the same value.  Otherwise it will hold the generated path. | `/tmp/tmp.fqLgZgCpCM/crt-pao-meta.zip` |
