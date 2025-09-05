# actions-pao-tool [![CI](https://github.com/hashicorp-forge/actions-pao-tool/actions/workflows/test.yml/badge.svg)](https://github.com/hashicorp-forge/actions-pao-tool/actions/workflows/test.yml)

_For internal HashiCorp use only. The output of this action is specifically designed to satisfy the needs of our internal deployment system, and may not be useful to other organizations._

This repository contains a handful of actions related to the PAO release channel.
Refer to the documentation of action for usage.

Tools related to release channel PAO.

### Release Process

1. Create a tag: `make release/tag`
1. If the changes show look correct, push the tag: `make release/push`
   This will push to main, the just-created tag, and the dynamic tags for the major and minor versions.
