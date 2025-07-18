.PHONY: launch dev repositories repositories-archive \
psql	# Aliases

launch: repositories gm-audio-service/.env	## launch the project via Docker. Will clone the required repositories and build the images for the containers.
	docker compose up -d

dev: repositories repositories-archive	## clone all repositories associated with the project for use as reference while developing.

gm-audio-service/.env: gm-audio-service
	@printf "\033[0;36mA template .env file was added to build the Audio Service image. A real token is required to run the Audio Service.\033[0m\n"
	echo "# Add a Discord Bot token, or create one at https://discord.com/developers/applications" >> "gm-audio-service/.env" ; \
	echo "DISCORD_BOT_TOKEN=<your_token_here>" >> "gm-audio-service/.env" ; \

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
	@printf "\033[1;33mThe Audio Service requires a Discord Bot token to function. See .env file.\033[0m\n"
	@printf "\033[1;33mThe GM system can run without the Audio Service, but functionality will be limited.\033[0m\n"

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

# ========================================
# Aliases
# ========================================

# Sync with the configuration in the `compose.yaml`
psql:	## connect to the DB container
	docker compose exec storage-db psql -h localhost -p 5432 -U postgres -d gm_song_storage
