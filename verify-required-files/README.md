# Verify Required Files

This action examines and validates PAO metadata files (created with [collect](../collect)):
* The target archive is verified to include at least one getting started guide and at least one eBOM CSV.
* Each eBOM is validated:
  * A getting started guide is included
  * No part number appears twice
  * Part numbers are properly formed (7 alphanumeric characters)
  * At least one of the parts corresponds to an artifact containing both the product name and the release version

## Usage

### Example

```yaml
    # ...
    - uses: hashicorp-forge/actions-pao-tool/verify-required-files@v1
      with:
        product: consul
        version: 1.20.0
        pao_meta_file: ./crt-pao-meta.zip
    # ...
```

### Inputs

| Name | Description | Example |
| - | - | - |
| product | The product being released | `consul` |
| version | The version being released | `1.20.0` |
| pao_meta_file | The PAO metadata archive to verify | `./crt-pao-meta.zip` |

### Outputs

This action produces no outputs.
