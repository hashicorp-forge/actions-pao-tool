# Extract Metadata Artifact

This action extracts an archive previously created with the [collect](../collect) action.
Basic validation is performed before extraction by calling
`scripts/verify-required-files.sh req-files $ARCHIVE`.

```yaml
# ...
    - name: Extract Metadata
      uses: hashicorp-forge/actions-pao-tool/extract-meta-artifact
      with:
        archive: path/to/crt-pao-meta.zip
        output-dir: path/to/meta-dir # optionally specify an output directory
# ...
```

After extraction, the output directory is available as output `output-dir`.
