.PHONY: launch dev repositories repositories-archive

launch: repositories	## launch the project via Docker. Will clone the required repositories and build the images for the containers.
	docker compose up -d

dev: repositories repositories-archive	## clone all repositories associated with the project for use as reference while developing.

# ========================================
# Repositories
# ========================================

repositories: \
gm-audio-service \
gm-song-storage \
gm-ui

repositories-archive: \
archive/gm-discord-music-bot \
archive/gm-discord-npc-chat \
archive/gm-discord-webhook-dice-roller \
archive/gm-soundboard-gui \
archive/gm-youtube-url-validator \

# Git will fail if the folder already exists and is not empty, so only clone if the folder does not exist.
define git-clone-safe
	@if [ ! -d "$(1)" ]; then \
		git clone $(2); \
	fi
endef

gm-audio-service:
	$(call git-clone-safe, gm-audio-service,git@github.com:riecenaidoo/gm-audio-service.git)

gm-song-storage:
	$(call git-clone-safe, gm-song-storage,git@github.com:riecenaidoo/gm-song-storage.git)

gm-ui:
	$(call git-clone-safe, gm-ui,git@github.com:riecenaidoo/gm-ui.git)

archive/gm-discord-music-bot:
	$(call git-clone-safe, archive/gm-discord-music-bot,git@github.com:riecenaidoo/gm-discord-music-bot.git)

archive/gm-discord-npc-chat:
	$(call git-clone-safe, archive/gm-discord-npc-chat,git@github.com:riecenaidoo/gm-discord-npc-chat.git)

archive/gm-discord-webhook-dice-roller:
	$(call git-clone-safe, archive/gm-discord-webhook-dice-roller,git@github.com:riecenaidoo/gm-discord-webhook-dice-roller.git)

archive/gm-soundboard-gui:
	$(call git-clone-safe, archive/gm-soundboard-gui,git@github.com:riecenaidoo/gm-soundboard-gui.git)

archive/gm-youtube-url-validator:
	$(call git-clone-safe, archive/gm-youtube-url-validator,git@github.com:riecenaidoo/gm-youtube-url-validator.git)
