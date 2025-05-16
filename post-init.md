After running the initialisation script, the project should be up and running.

- Visit http://localhost:4200/
- For the v2/gm-audio-service to work, you will need to supply a Discord Bot Token in 'v2/gm-audio-service/.env'.
The site should load and be usable without it, you will just not be able to interact with the Discord Bot.
- The project should be listed in your Docker Desktop where you can stop or start it, 
otherwise you can use `docker compose -f v2/compose.yaml down` to take down (delete) the project containers.
