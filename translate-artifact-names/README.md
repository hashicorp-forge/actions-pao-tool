# Translate Artifact Names

This action translates native build artifact names to short names suitable for PAO distribution.

```yaml
# ...
    - name: Translate
      uses: hashicorp-forge/actions-pao-tool/translate-artifact-names@main
      with:
        input-dir:  before-xlate  # This directory must exist and contain the artifacts.
        output-dir: after-xlate
# ...
```

After translation, the artifacts are in `output-dir` with their shortened names.
