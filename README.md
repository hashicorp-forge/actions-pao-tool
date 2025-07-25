# actions-pao-tool [![CI](https://github.com/hashicorp-forge/actions-pao-tool/actions/workflows/test.yml/badge.svg)](https://github.com/hashicorp-forge/actions-pao-tool/actions/workflows/test.yml)

_For internal HashiCorp use only. The output of this action is specifically designed to satisfy the needs of our internal deployment system, and may not be useful to other organizations._

This repository contains a handful of actions related to the PAO release channel.
Refer to the documentation of action for usage.

Tools related to release channel PAO.

### Release Process

1. Create a new tag at the commit to release.
   Follow SemVer semantics.
1. Update dynamic tags (e.g. `v1`) to match the most recent release.
