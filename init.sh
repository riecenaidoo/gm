#!/bin/bash

for dir in v1 v1/soundboard v2 
do
	for repo in $(cat $dir/repos.txt) 
	do 
		# -C to set the working dir for a Git cmd
		git -C $dir clone $repo
	done
done
