@echo off
for %%d in (v1 v1/soundboard v2) do (
	for /F %%l in (%%d/repos.txt) do (
		REM -C is to set the working directory for a Git command
		git -C %%d clone %%l
	)
)