# Bashetize
- This is a Turn-key bash configuration implementation
- Eases bash configuration
- Jumpstarts your workflow
- Most functionality is inherited, only a minor adjustment needed
- Currently configured for RHEL/CentOS/AWSLinux 

## Includes
- global `.gitconfig`, which provides some nice eye candy to terminal use, git branch shows up on your PS1 prompt, includes branch, diff, jstatus color configurations, grep credential, sslverify and core customizations for e.g. autocrls, filemode, ignorecase, includes your name and email so you only have to configure it once, and not for every repo you pull down. 
- bash PS1 terminal colors so you can customize them for each server, to readily identify (please save all RED for root user only)
- engineer / developer bash aliases (see notes below for more details on this)
- gnu screen custom layout, and updated gnu binary (4.06.02) with symlink in bin (which is also added to the PATH in the .bashrc.custom, incase it doesnt exist).  Just running `$ screen` by default will open in a 3 pane configuration whic can be later customized in the layout file.  
- vim colors(multitude of themes) and a custom `.vimrc`.  To see them all when in vim just run `:colorscheme ` then use the tab and arrow keys to navigate them. 
- PATH extensions, e.g. adds ~/bin to the PATH (bin is a good place to keep your own custom bash scripts)
- `.ssh/config`; host examples, and multiplexing using sockets to expedite your ssh connecting, e.g. `$ ssh tf`
- x11 and tunnel support through ssh
- `~/bin` files includes custom scripts which are mostly developer tools.  These scripts are growing as the need arises, and will be pushed up to origin as they are created. E.g. `composer`, `loopsitecheck` which curl tests a given site for existance, and `counthere` which counts dirs and files in the path.  If any bin binarys are compiled to a certain distro, you will find that distro subfolder in there, e.g. `centos6` then that binary will be found in that subfolder, and symlinked in bin.  If you want to use this on a different distro, you will need to make your own subdir in there for that distro , and compile/make the binary from source, then add your own symlink, which will automatically become available for use since `~/bin` is already in your path. 
- dircolors, which allows custom colors your directorys and files, helping you to easily decipher and recognize them

## Instructions
1. clone the package onto your server
2. Install the submodules `git submodule update --init`
3. copy the `userhome/` files into your home directory from whatever path you cloned it. 
    `$ rsync -rlp --exclude=".git*" ~/packges/bashetize/userhome/ ~/`
4 ensure `~/.bashrc.custom` is sourced (in .bashrc normally)
5. update your username and email to `~/.gitconfig` 
6. Make sure your ssh config permissions are correct 
    `$ chmod 600 ~/.ssh/config`
- Optional; update your colors; open `~/etc/.bash-my-colors` and change the first 4-6 lines to your desired colors.  E.g. change the word `BIGreen` to `BICyan`, etc..  Refer to `~/etc/.bash-colours` to see the common names of which colors are available. 

## Notes
- some of the more useful aliases
-- `l` which is `ls-la`, `h`, which is `cd ~/`, `u`, which is `cd ..`
-- `gd`, which is git diff, `gsh` which is `git status`, `gr` which is `git remote -v`
-- Read the `~/etc/.bash-alias` file to see them all, and add your aliases to this file. 
- If you use other terminal colors, e.g.  mac terminal with a profile that changes colors, then the defaul colors might clash.  In this case you will want to either try to disable the mac terminal profile/theme, or switch the profile to "Pro" (ok to change font colors, but more importantly is a dark background).  Alternately to switching your terminal profile/theme you can edit the `~/etc/.bash-profile-global` file to source `~/etc/.bash-my-colors-plain` instead of `~/etc/.bash-my-colors`  
- See .vimrc to adjust your vim colorscheme
- If your a gnu screen user
-- To use the gnu screen layout, you will need a later version of screen, e.g. 4.2. make then compile that into your bin dir, and add an alias, or make then install the latest version of it onto your stack as sudo. The new custom config will work right away, use `screen -RA` to launch, and ctrl + a D to detach.
