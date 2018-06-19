# Bashetize
- Turn-key bash functionality
- Eases bash configuration
- Jumpstarts your workflow
- Most functionality is inherited, minor adjustments needed 

## Includes
- global `.gitconfig`, and git branch shows up on your PS1 prompt
- bash PS1 terminal colors
- engineer / developer aliases
- gnu screen custom layout
- vim colors(multitude of themes) and a custom `.vimrc`
- PATH extensions
- `.ssh/config`; host examples, and multiplexing using sockets
- `~/bin files` includes `composer`, `loopsitecheck` which curl tests a given site for existance, and `counthere` which counts dirs and files in the path
- x11 and tunnel support
- dircolors, which allows custom colors your directorys and files, helping you to easily decipher and recognize them

## Instructions
1. copy files into your home directory
2. ensure `~/.bashrc.custom` is sourced (in .bashrc normally)
3. add your username and email to `~/.gitconfig` 
- Optional; update your colors; open `~/etc/.bash-my-colors` and change the first 4 lines to your desired colors.  Refer to `~/etc/.bash-colours` to see the common names of which colors are available. 

## Notes
- some of the more useful aliases
-- `l` which is `ls-la`, `h`, which is `cd ~/`, `u`, which is `cd ..`
-- `gd`, which is git diff, gsh` which is `git status`, `gr` which is `git remote -v`
-- Read the `~/etc/.bash-alias` file to see them all, and add your aliases to this file. 
- If you use other terminal colors, e.g.  mac terminal with a profile that changes colors, then the defaul colors might clash.  In this case you will want to either try to disable the mac terminal profile/theme, or switch the profile to "Pro" (ok to change font colors, but more importantly is a dark background).  Alternately to switching your terminal profile/theme you can edit the `~/etc/.bash-profile-global` file to source `~/etc/.bash-my-colors-plain` instead of `~/etc/.bash-my-colors`  
- See .vimrc to adjust your vim colorscheme
- If your a gnu screen user
-- To use the gnu screen layout, you will need a later version of screen, e.g. 4.2. make then compile that into your bin dir, and add an alias, or make then install the latest version of it onto your stack as sudo. The new custom config will work right away, use `screen -RA` to launch, and ctrl + a D to detach.
