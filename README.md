# actions-pao-tool [![CI](https://github.com/hashicorp-forge/actions-pao-tool/actions/workflows/test.yml/badge.svg)](https://github.com/hashicorp-forge/actions-pao-tool/actions/workflows/test.yml)

_For internal HashiCorp use only. The output of this action is specifically designed to satisfy the needs of our internal deployment system, and may not be useful to other organizations._

Tools related to release channel PAO.

## Usage

To create the `crt-pao-meta.zip` artifact containing (CSV) eBOMs, the Getting Started guide, etc.:

```yaml
steps:
  # ...
  - uses: actions/checkout@latest # ...
  - uses: hashicorp-forge/actions-pao-tool/collect@v1 # ...
```
