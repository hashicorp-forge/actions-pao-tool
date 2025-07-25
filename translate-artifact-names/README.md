# Translate Artifact Names

This action translates native build artifact names to short names suitable for PAO distribution.
The resulting names must appear in an eBOM for the artifacts to be published.
The typical use case for this action is staging artifacts for release.

## Usage

### Example

```yaml
    # ...
    - name: Translate
      uses: hashicorp-forge/actions-pao-tool/translate-artifact-names@main
      with:
        input-dir:  before-xlate  # This directory must exist and contain the artifacts.
        output-dir: after-xlate
    # ...
```

### Inputs

| Name | Description | Example |
| - | - | - |
| input-dir | The directory containing artifacts to rename | `./in` |
| output-dir | The directory containing renamed artifacts | `./out` |

### Outputs

| Name | Description | Example |
| - | - | - |
| output-dir | The directory containing renamed artifacts.  This is always the same as the input of the same name and is included only for convenience in authoring workflows. | `./out` |
