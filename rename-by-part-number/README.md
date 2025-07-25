# rename-by-part-number

This action reads eBOM CSV files from a metadata archive (created with [collect](../collect))
and uses the part numbers to rename artifacts in preparation for upload to PAO.

This action fetches artifacts from Artifactory using the `jfrog` CLI tool, which *_must already_* be configured.
The renamed artifacts are uploaded to Artifactory.

The typical use case for this action is preparing artifacts for production release.

## Usage

### Example

```yaml
    # ...
    - name: Rename by Part Number
      uses: hashicorp-forge/actions-pao-tool/rename-by-part-number@v1
      with:
        product: consul
        version: 1.20.0
        commit_sha: abc1234...
        pao_meta_dir: ./pao-meta
        source_bucket: source-bucket
        destination_bucket: dest-bucket
    # ...
```

### Inputs

| Name | Description | Example |
| - | - | - |
| product | The product being released | `consul` |
| version | The version being released | `1.20.0` |
| commit_sha | The commit SHA being released | `a625a45c651951dc26b7d0a3b9df8b00eed575cd` |
| pao_meta_dir | The directory where PAO metadata files were extracted (see [extract-meta-artifact](../extract-meta-artifact)) | `./pao-meta` |
| source_bucket | The repository holding the artifacts ready to be renamed | `source-bucket-local` |
| destination_bucket | The repository where renamed artifacts will be uploaded | `dest-bucket-local` |

### Outputs

This action has no outputs.
