#!/bin/bash

echo "Cloning Git Repositories..."
for dir in v1 v1/soundboard v2 
do
	for repo in $(cat $dir/repos.txt) 
	do 
		# -C to set the working dir for a Git cmd
		git -C $dir clone $repo
	done
done

echo
echo "Initialising gm-audio-service..."
echo DISCORD_BOT_TOKEN= > v2/gm-audio-service/.env

echo
echo "Building the project (v2)..."
docker compose -f v2/compose.yaml up --build -d

echo
cat post-init.md
echo
echo
read -p "Press any key to continue..."