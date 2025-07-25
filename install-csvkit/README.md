# install-csvkit

The `install-csvkit` installs `csvkit`,
a Python toolkit for manipulating CSV files from shell scripts.
Actions in `actions-pao-tool` will install `csvkit` automatically,
but this action may be helpful to callers or for tests.

This action accepts no inputs and returns no outputs.

## Usage

### Example:

```yaml
steps:
    # ...
    - uses: hashicorp-forge/actions-pao-too/install-csvkit@v1
```
