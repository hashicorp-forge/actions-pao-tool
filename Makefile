
.PHONY: release/*
release/show-versions: ## Show current and next versions; note that local changes effect the output: make release/show-versions
	@./scripts/release show-versions

release/tag: ## Create a release tag: make release/tag
	@./scripts/release tag

release/push: ## Push a release tag to GitHub: make release/push
	@./scripts/release push

########################################

# allow `make help` to show available make targets
.PHONY: help
help: ## Show this help
	@echo "Valid targets:"
	@grep --extended-regexp --no-filename '^[a-zA-Z/_-]+:.*?## .*$$' $(MAKEFILE_LIST) | sort | awk 'BEGIN {FS = ":.*?## "}; {printf "\033[36m%-15s\033[0m %s\n", $$1, $$2}'

# Use this to require an environment variable to be set.  See docker.mk for
# example usage.
# Source: https://stackoverflow.com/a/36045843
require-env-var-%:
	$(if ${${*}},,$(error You must pass the $* environment variable))

# Use this to print out the value of a makefile variable; e.g.:
#
#   make print-GIT_COMMIT
#
# Source: https://stackoverflow.com/a/25817631
print-% : ; ## Show a variable value: make print-SWAGGER
	@echo $* = $($*)
