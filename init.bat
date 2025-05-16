@echo off

echo Cloning Git Repositories...
for %%d in (v1 v1/soundboard v2) do (
	for /F %%l in (%%d/repos.txt) do (
		REM -C is to set the working directory for a Git command
		git -C %%d clone %%l
	)
)

echo.
echo Initialising gm-audio-service...
echo DISCORD_BOT_TOKEN= > v2/gm-audio-service/.env

echo.
echo Building the project (v2)...
docker compose -f v2/compose.yaml up --build -d

echo.
type post-init.md
echo.
echo.
pause