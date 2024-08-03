# README

Basic, top level project information.

This repository is a skeleton structure for organising the different units that compose this project.
Each unit is maintained (or archived) in its own repository.
This repository contains scripts for retrieving all these units and organising them neatly and consistently across different workstations.
This repository contains documentation and reading material for this project.

## Project Structure

`ls -d v*/* | xargs -n 1 ./init.sh` - Linux, Clone down all projects

### File System

Top level directories separate versions of the project.
Each version contains source code, and deployment scripts specific to that version of the project.

### Repositories

Each component of the system has its own repository. 
There are initialisation scripts setup to pull these repositories to the local machine, after this repository has been pulled.
There are `.gitignore` files to keep these repositories outside of this one.

## Project Versioning

### V1 - P.O.C [DONE]

A proof of concept that should have been archived earlier. The mistake was continuing to add features and experiment ontop of a design that was not meant to be long term. V1 worked well for what it was meant to do: prove the concept works, be usable and offer a short term solution while a fully fledged solution was being built.

### V2 - Application [IN PROGRESS]

System that could be deployed locally as a live service, for personal use.

#### Changelog

- Decouple storage from interface; storage is now a standalone component of the system.

### V3 - Authentication [TODO]

System that could be deployed online as a live service, with access restricted to a small group of friends.
