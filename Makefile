# =============================================================================
# configs:/makefiles/v1.2.0;/root-repository/v1.1.0
# =============================================================================

# See [7.2.1 General Conventions for Makefiles](https://www.gnu.org/prep/standards/html_node/Makefile-Basics.html)
SHELL := /bin/sh

init: project git	## default (no-arg) target to initialise the Project and local repository

# See [7.2.6 Standard Targets for Users > 'all'](https://www.gnu.org/prep/standards/html_node/Standard-Targets.html)
all: init repos docker	## primary target for creating all Project artifacts

start: docker	## start the Project
	$(COMPOSE) start

stop:	## stop the Project
	$(COMPOSE) stop

build: docker	## build the Project

log:	## show logs of the Project
	$(COMPOSE) logs

.PHONY: init all start stop build log
# =============================================================================
# Environment Variables
# =============================================================================
# [6.2.4 Conditional Variable Assignment](https://www.gnu.org/software/make/manual/html_node/Conditional-Assignment.html)
# [6.10 Variables from the Environment](https://www.gnu.org/software/make/manual/html_node/Environment.html)
COMPOSE ?= docker compose
# =============================================================================
# Script Macros
# =============================================================================
XARGS := xargs -0 --no-run-if-empty
PLAINTEXT_FILTER := $(XARGS) file --mime-type | awk -F: '/text\// { printf "%s\0", $$1 }'
# =============================================================================
# Project
# =============================================================================
MADE := ./.made

project: $(MADE)	##> alias for initialising the Project

$(MADE):
	mkdir $(MADE)

rm-project:	##> remove all Project initialisation artifacts
	rm -rf $(MADE)

.PHONY: project rm-project
# =============================================================================
# Git
# - [Git Hooks](https://git-scm.com/book/ms/v2/Customizing-Git-Git-Hooks)
# =============================================================================
DIFF_FILES := git diff HEAD --diff-filter=ACM --name-only --relative -z
UNTRACKED_FILES := git ls-files --others --exclude-standard --full-name -z

git: .git/hooks/pre-commit	##> alias for initialising the local repository; creates Git artifacts

.git/hooks/pre-commit: ./.scripts/pre-commit.sh	| $(MADE)	## updates the pre-commit hook in the local repository
	@if [ -f .git/hooks/pre-commit ]; then \
		cat .git/hooks/pre-commit >> $(MADE)/pre-commit; \
	fi
	cat .scripts/pre-commit.sh > .git/hooks/pre-commit
	chmod +x .git/hooks/pre-commit	# Ensure the script is executable.
	@printf '\n\033[0;33m%s\033[0m\n' "Pre-Commit Hook installed."
	@printf '\tHint:\t\033[0;36m%s\033[0m\n' "rm .git/hooks/pre-commit"
	@printf '\tHint:\t\033[0;36m%s\033[0m\n' "make rm-git"

rm-git:	##> remove all Git artifacts produced by this script
	rm -f .git/hooks/pre-commit .git/hooks/pre-push
	@printf '\n\033[0;33m%s\033[0m\n' "Git Hook(s) removed."
	@printf '\tHint:\t\033[0;36m%s\033[0m contains any overwritten existing Git hooks.\n' "$(MADE)"

.PHONY: git rm-git
# =============================================================================
# Repositories
# =============================================================================
REPOSITORIES := gm-ui gm-discord gm-storage

repos: $(REPOSITORIES)	## alias for cloning all Project repositories

gm-%:
	git clone git@github.com:riecenaidoo/gm-$*.git
	@if $(MAKE) -C ./gm-$* init -n 2>/dev/null; then \
		$(MAKE) -C ./gm-$* init; \
	fi

ARCHIVE := ./archive

$(ARCHIVE):
	mkdir $(ARCHIVE)

ARCHIVED_REPOSITORIES := \
	$(ARCHIVE)/gm-discord-music-bot  \
	$(ARCHIVE)/gm-discord-npc-chat \
	$(ARCHIVE)/gm-discord-webhook-dice-roller \
	$(ARCHIVE)/gm-soundboard-gui \
	$(ARCHIVE)/gm-youtube-url-validator

archives: $(ARCHIVE) $(ARCHIVED_REPOSITORIES) ##> alias for cloning all archived Project repositories

$(ARCHIVE)/gm-%:
	git -C $(ARCHIVE) clone git@github.com:riecenaidoo/gm-$*.git

rm-repos:	##> alias for removing all Project repositories
	rm -rf $(REPOSITORIES)
	rm -rf $(ARCHIVE)

.PHONY: repos archives rm-repos
# =============================================================================
# Docker
# =============================================================================
docker: $(REPOSITORIES)	##> create all Docker artifacts
	$(COMPOSE) create

rm-docker:	##> remove all Docker artifacts produced by this script
	$(COMPOSE) down
	@printf '\nHint:\t\033[0;36m%s\033[0m\t (Prune volume data)\n' "$(COMPOSE) down --volumes"

.PHONY: docker rm-docker
# =============================================================================
# Formatting
# =============================================================================
TRIM_CHECK := $(PLAINTEXT_FILTER) | $(XARGS) grep -lZ '[[:blank:]]$$'
TRIM := $(TRIM_CHECK) | $(XARGS) sed -i 's/[ \t]*$$//'

format: format-diff format-untracked	## alias to run formatting (format-diff) (format-untracked) rules
	git status -s

format-diff: ##> run formatting on modified (git diff HEAD) files
	$(DIFF_FILES) | $(TRIM)

format-diff-check: ##> check formatting on modified (git diff HEAD) files
	@TRAILING_WHITESPACE_FILES=$$($(DIFF_FILES) | $(TRIM_CHECK)); \
	if [ -n "$$TRAILING_WHITESPACE_FILES" ]; then \
		  printf '\033[0;31m%s\033[0m' "Trailing Whitespaces!"; \
		  printf '\t- %s\n' "$$TRAILING_WHITESPACE_FILES"; \
		exit 1; \
	fi

format-untracked:	##> run formatting on untracked files
	$(UNTRACKED_FILES) | $(TRIM)

format-all:	##> run formatting on all files
	find . -maxdepth 1 -type f -print0 | $(TRIM)
	find .scripts/ -type f -print0 | $(TRIM)

.PHONY: format format-diff format-untracked format-all
# =============================================================================
# Utilities
# =============================================================================
# See [7.2.6 Standard Targets for Users > 'clean'](https://www.gnu.org/prep/standards/html_node/Standard-Targets.html)
clean: rm-project rm-git rm-repos rm-docker	## alias for cleaning up all artifacts produced by this Project

help:  ## show a summary of available targets
	@printf "%s\n" \
	"===============================================================================" \
	" General Commands" \
	"==============================================================================="
	@grep -E '^[a-zA-Z_-]+:.*?## .*$$' $(MAKEFILE_LIST) \
		| awk 'BEGIN {FS = ":.*?## "}; { \
			cmd = $$1; desc = $$2; \
			gsub(/\(([^)]*)\)/, "\033[34m&\033[0m", desc); \
			printf "  \033[36m%-21s\033[0m %s\n", cmd, desc \
		}'
	@printf "%s\n" \
	"==============================================================================="

help-ext:  ## show all available targets
	@printf "%s\n" \
	"===============================================================================" \
	"Available Commands" \
	"==============================================================================="
	@grep -E '^[a-zA-Z0-9_-]+:.*?##>? ' $(MAKEFILE_LIST) \
		| awk 'BEGIN {FS = ":.*?##>? "}; { \
			cmd = $$1; desc = $$2; \
			gsub(/\(([^)]*)\)/, "\033[34m&\033[0m", desc); \
			printf "  \033[36m%-21s\033[0m %s\n", cmd, desc \
		}'
	@printf "%s\n" \
	"==============================================================================="

.PHONY: clean help help-ext
# =============================================================================
# ANSI Color Escape Codes
# =============================================================================
# YELLOW='\033[0;33m'
# RED='\033[0;31m'
# GREEN='\033[0;32m'
# CYAN='\033[0;36m'
# BLUE='\033[0;34m'
# NONE='\033[0m'
# =============================================================================
