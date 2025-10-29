# configs/makefiles/v1.1.1
# See [7.2.1 General Conventions for Makefiles](https://www.gnu.org/prep/standards/html_node/Makefile-Basics.html)
SHELL := /bin/sh

init: project repos	## default (no-arg) target to initialise the Project

# See [7.2.6 Standard Targets for Users > 'all'](https://www.gnu.org/prep/standards/html_node/Standard-Targets.html)
all: init archives	## primary target for creating all Project artifacts

.PHONY: init all
# ========================================
# Project Initialisation
# ========================================
MADE := ./.made

project: $(MADE)	## alias for initialising the Project

$(MADE):
	mkdir $(MADE)

rm-project:	##> remove all Project initialisation artifacts
	rm -rf $(MADE)

.PHONY: project rm-project
# ========================================
# Composite Repositories
# ========================================
REPOSITORIES := gm-ui gm-discord gm-storage

repos: $(REPOSITORIES)	## alias for cloning all Project repositories

gm-%:
	git clone git@github.com:riecenaidoo/gm-$*.git
	$(MAKE) -C ./gm-$* init

rm-repos:	##> alias for removing all Project repositories
	rm -rf $(REPOSITORIES)

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

rm-archives:	##> alias for removing all archived Project repositories
	rm -rf $(ARCHIVED_REPOSITORIES)
	rmdir $(ARCHIVE)

$(ARCHIVE)/gm-%:
	git -C $(ARCHIVE) clone git@github.com:riecenaidoo/gm-$*.git

.PHONY: repos rm-repos archives	rm-archives
# ========================================
# Utilities
# ========================================
# See [7.2.6 Standard Targets for Users > 'clean'](https://www.gnu.org/prep/standards/html_node/Standard-Targets.html)
clean: rm-project rm-repos rm-archives	## alias for cleaning up all artifacts produced by this Project


help:  ## show a summary of available targets
	@printf "%s\n" \
	"------------------" \
	" General Commands" \
	"------------------"
	@grep -E '^[a-zA-Z_-]+:.*?## .*$$' $(MAKEFILE_LIST) \
		| awk 'BEGIN {FS = ":.*?## "}; { \
			cmd = $$1; desc = $$2; \
			gsub(/\(([^)]*)\)/, "\033[34m&\033[0m", desc); \
			printf "  \033[36m%-21s\033[0m %s\n", cmd, desc \
		}'
	@printf "%s\n" \
	"------------------"

help-ext:  ## show all available targets
	@printf "%s\n" \
	"------------------" \
	"Available Commands" \
	"------------------"
	@grep -E '^[a-zA-Z0-9_-]+:.*?##>? ' $(MAKEFILE_LIST) \
		| awk 'BEGIN {FS = ":.*?##>? "}; { \
			cmd = $$1; desc = $$2; \
			gsub(/\(([^)]*)\)/, "\033[34m&\033[0m", desc); \
			printf "  \033[36m%-21s\033[0m %s\n", cmd, desc \
		}'
	@printf "%s\n" \
	"------------------"

.PHONY: clean help help-ext
# ========================================
# ANSI Color Escape Codes
# ========================================
# YELLOW='\033[0;33m'
# RED='\033[0;31m'
# GREEN='\033[0;32m'
# CYAN='\033[0;36m'
# BLUE='\033[0;34m'
# NONE='\033[0m'
# ========================================
