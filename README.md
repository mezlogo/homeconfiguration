# home configuration

Getting started:
- run `init.sh`
- run `stowit.sh`

## 1. prerequisite

Create all necessary directories, cos' stow links every NOT EXISTED file and directory.

In case of "extending" dirs, e.g. profile.d, zsh.d e.t.c. it should be created and NOT symlinked.

## 2. login environment

User environment is set by sourcing everything from ~/.profile.d directory.

If any stow module wants to extend environment it should create a shell script inside ~/.profile.d, for instance `~/.profile.d/50_my_cli_app_configuration.sh`
