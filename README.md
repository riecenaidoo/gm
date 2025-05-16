A collection of tools to assist a **Gamemaster** in running a **TTRPG**, especially one hosted virtually over **Discord**. 

This repository is the root of the **Gamemaster** project and serves to organise all the related `gm` project repositories. It contains initialisation and deployment scripts, as well as general project information.
## Structure

- The primary branch name is `project` to make it easily identifiable I am no longer within a `gm` repository while working with Git off the command line.
- `repos.txt` files are used to classify the `gm` repositories - either for versioning, or to group them logically. The `init` scripts can be used to initialise (pull down) all `gm` repositories (leverages the `repos.txt` file).

## Versioning

### V1 - P.O.C (DONE)

A proof of concept to see whether the tools I wanted to create could be useful, and whether they could integrate with Discord.
- **They are useful and can integrate with Discord.**

**Soundboard** (*this is the primary tool I want to create, the one that solves my biggest pain point*)
This proof of concept should have been archived earlier. The mistake was continuing to add features and experiment on-top of a design that was not meant to be long term. V1 worked well for what it was meant to do: prove the concept works, be usable and offer a short term solution while a fully fledged solution was being built.

### V2 - Application (IN PROGRESS)

A system that could be deployed locally as a live service, for personal use.

#### Changelog

- Decoupled the storage from interface; storage is now a standalone component of the system.

### V3 - Authentication (TODO)

A system that could be deployed online as a live service, with access restricted to a small group of friends.
