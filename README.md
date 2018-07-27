# Bashetize
- This is a Turn-key bash configuration implementation
- Eases bash configuration
- Jumpstarts your workflow
- Most functionality is inherited, only a minor adjustment needed
- Currently configured for RHEL/CentOS/AWSLinux 
- will also work for rootA

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
There are two ways to run this.  
- One way is automatically from `/etc/profile.d` so that from an administrative level, it will auto install for any user that logs on after creating a symlink for `etc/bashetize.sh` in your `/etc/profile.d`
- The other way is you can run the install.sh script to copy files into your user directory. 
- Either way you choose, it will not overwrite anything that already exists so you dont need to worry about losing any configuration changes. 

### Method 1 install to `/etc/profile.d`
1. Clone the package onto your server somewhere in your user dir.
2. cd into the package
   `$ cd bashetize`
3. Install the submodules `git submodule update --init`
4. Move the package to a home, a suitable location would be to `/usr/local/src`
   `sudo mv bashetize /usr/local/src`
   you can leave the permissions to which ever user is the current package owner (dont chown to root or there will be copy issues)
4. symlink the `bin/bashetize.sh script to `/etc/profile.d`
   `$ sudo ln -s `/usr/local/src/bashetize/bin/bashetize.sh /etc/profile.d`
On the next login, it will auto install, as long as you dont have a ~/.bashrc.custom file

### Method 2 copy files directly to your user dir
1. clone the package. 
2. cd into the package
   `$ cd bashetize`
3. Install the submodules `git submodule update --init`
4. Run the install.sh script to copy the files into your home dir. 
   - Be sure that you keep the install script inside the git package, and run it from the dir it resides in, since it looks locally(relative path) for its file
   `$ ./install.sh`. 

### After installation for a given user
1. 1. If your not using a system controlled by puppet, or one that doesnt source .bashrc.custom from the .bashrc file, ensure `~/.bashrc.custom` is sourced (in .bashrc normally) by adding the following lines to your .bashrc
   ```
   if [ -f ~/.bashrc.custom ]; then
       . ~/.bashrc.custom
   fi
   ```
2. update your username and email on `~/.gitconfig` 
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

## known issues
- When the directory `.ssh/cm_socket`, specified on .ssh/config, is copied, if the owner is other than the one who runs the copy command, rsync complains that it cand read into the directory.  This is acceptable because its empty anyway, and its only that dir which is needed, which does successfuly copy anyway. This happends because the `cm_socket` dir needs to be set to 700, so for now it is 700.  At a later time the `cm_socket can be set to 755, or 775, then the rsync command, or another command issued, can be adjusted to set it to 700 afgter the copy.   
- If you opt for the global profile.d installation option, do a careful server restart test to see if any user with nologin, or non interactive shell is affected, e.g. that all your services start correctly.  You will know if your server doesnt startup and become accessible as fast as normal, or if you view your system logs to see if any services had any problem starting. There needs to be a check of some sort on the profile.d/bashetize.sh script to check for a certain group of users, or that user isnt nologin, or non interactive, because in test cases it was being triggered by something for some reason.  . 
