# Bashetize
- This is a Turn-key bash configuration implementation
  - Especially useful in multiple host environments where adding this level of customization to your bash user can be otherwise time consuming.  
  - Allows consistency across many distros and hosts.  
  - Easily change your `PS1` color, on each host, to help idendify the host your logged into (by color). (Root is red, by default, so that you never make a mistake not knowing your logged in as root)
- Eases bash configuration
- Jumpstarts your workflow
- Most functionality is inherited, only "very" minor adjustment needed
- Currently tested and configured for RHEL/CentOS/AWSLinux/Almalinux (Docker), among others. For some very lightweight containers or other distros some minor adjustment may be needed.
- Intended for both root, and non root user

# Dependencies
- vim
- git
- rsync
- wget

Install the above binaries first, e.g. `dnf install vim git rsync wget`
 
## Includes
This code, when `./install.sh` is ran, adds the following to whatever user you bashetize..
- your global `~/.gitconfig`, which includes your name and email so you only have to configure it in one place globally, and wont have to for every repo you pull down.  It also provides improvement to git stdout, git branch shows up on your PS1 prompt, includes branch, diff, jstatus color configurations, grep credential, sslverify and core customizations for e.g. autocrls, filemode, ignorecase.  Adjust to your needs, but is ready for any standard git collaboration as-is.
- bash PS1 terminal colors so you can customize them for each server, to readily identify (suggested to use all RED for root user only, to aid in recognition when your in root).  This is the initial function of bashetize, the quest to get good terminal colors, and have the ability to easily edit them (see `~/etc/.bash-my-colors`)
- engineer / developer bash aliases (see notes below for more details on this)
- gnu screen custom layout, and updated gnu binary (4.06.02) with symlink in bin (which is also added to the PATH in the .bashrc.custom, incase it doesnt exist).  Just running `$ screen` by default will open in a 3 pane configuration whic can be later customized in the layout file.  Alot of effort has been made to streamline gnu screen, some use tmux, but thats the easy way out, and doesnt contain everything gnu screen does (relative opinion). 
- vim colors(multitude of themes) and a custom `.vimrc`.  To see them all when in vim just run `:colorscheme ` then use the tab and arrow keys to navigate them. This is another major piece of bashetize, to get vim to display in full 256 color, so when you use its colorschemes it actually works.  its hard to tell when its not working right, because it still displays colors, but they just arent vibrant, but when it is, you can see all the extra colors. (try jellybeans colorscheme, it works great for ansible, and other syntax) 
- PATH extensions, e.g. adds `~/bin` to the PATH (bin is a good place to keep your own custom bash scripts).  Bashetize includes some helper functions/scripts that will be placed into your `~/bin`, so this activates them, and allows you to easily drop in more during your development.  COnsider symlinking your git source code scripts directly to ~/bin to have a place they can be available on your path without having to keep adding more dirs to your path. 
- `.ssh/config`; host examples, and multiplexing using sockets to expedite your ssh connecting, e.g. `$ ssh tf`
- x11 and tunnel support through ssh
- `~/bin` files includes custom scripts which are mostly developer tools.  These scripts are growing as the need arises, and will be pushed up to origin as they are created. E.g. `composer`, `loopsitecheck` which curl tests a given site for existance, and `counthere` which counts dirs and files in the path.  If any bin binarys are compiled to a certain distro, you will find that distro subfolder in there, e.g. `centos6` then that binary will be found in that subfolder, and symlinked in `~/bin`.  If you want to use this on a different distro, you will need to make your own subdir in there for that distro , and compile/make the binary from source, then add your own symlink, which will automatically become available for use since `~/bin` is already in your path. 
- dircolors, which allows custom colors your directorys and files, helping you to easily decipher and recognize them

## Instructions
There are two ways to run this.  
1. One way is automatically from `/etc/profile.d` so that from an administrative level, it will auto install for any user that logs on after creating a symlink for `etc/bashetize.sh` in your `/etc/profile.d`
2. The other way is you can run the `install.sh` script. 
- Either way you choose, it will not overwrite anything that already exists so you dont need to worry about losing any configuration changes. 
- This is for linux, so during development since thre is a risk of `CRLF`'s, you can set your git config to use `LF` before commiting: `git config --global core.autocrlf input`.  Its important to not introduce `CRLF`'s into the code base.   Its setup for linux dev, not windows.  Its setup to correct windows `LF` automatically. 
  - If you see this issue after a fresh checkout, To rescue a file that has `CR`'s on it, where you see an `^M Interpreter` issue, you can clean them up on the fly.  If its a `.vim` script, it needs `:w ++ff=unix`, or else you can use `dos2unix` to clean up most other files.  You may need to clean up `.screenrc` or its layout files manually since dos2unix doesnt handle that kind of special syntax.  If you are editing files in windows, and are careful how files are edited and keep the encoding correct you shouldnt have issues.  But if you just use vim in the first place, or some linux editor, you wont have issues in the first place.   

### Method 1 clone then install to user dir using script (recommended)
1. As a standard non-root user, clone the package. 
2. Navigate into the package
   `$ cd bashetize`
3. Run the `install.sh` script to copy the files into your home dir. (note the install script runs the submodule update --init automatically now)
  - Be sure that you keep the install script inside the git package, and run it from the dir it resides in, since it looks locally(relative path) for its file
   `$ ./install.sh`. 
   - If you have root privileges, you can safely install as root user also, which adds alot of the configs to your root account (makes term colors red so you know when your in root, etc..): `sudo -i` then `cd bashetize` (in your home dir?) then run the `install.sh` script (as root).  Since you will be logged in as `root`, it will copy the appropriate files to `/root`.  You can see those files here https://github.com/brian-lamb-software-engineer/bashetize/tree/master/root 

### Method 2 clone then manually install to `/etc/profile.d` (not recommended, it hasnt been fully developed, some outside development would be appreciated here just submit a PR :-)
1. Clone the package onto your server somewhere in your user dir.
2. cd into the package
   `$ cd bashetize`
3. Install the submodules `git submodule update --init`
4. Move the package to a home, a suitable location would be to `/usr/local/src`
   `sudo mv bashetize /usr/local/src`
   you can leave the permissions to which ever user is the current package owner (dont chown to root or there will be copy issues)
4. symlink the `bin/bashetize.sh script to `/etc/profile.d`
   `$ sudo ln -s `/usr/local/src/bashetize/bin/bashetize.sh /etc/profile.d`
- On the next login, it will auto install, as long as you dont have a ~/.bashrc.custom file already in place.

### After installation for a given user
1. 1. If your not using a system controlled by puppet(which uses `.bashrc.custom` by default), or one that doesnt source `.bashrc.custom` from the `.bashrc` file, ensure `~/.bashrc.custom` is sourced (in .bashrc normally) by adding the following lines to your .bashrc or .profile
   ```
   if [ -f ~/.bashrc.custom ]; then
       . ~/.bashrc.custom
   fi
   ```
  - Install is now complete. (check if any errors, to ensure you have all the correct dependencies installed, e.g. if runnign a minimal docker container you may need to add wget, rsync first)
  - Continue configuring below. 
2. update your username and email on `~/.gitconfig` 
  - Optional; update your colors; open `~/etc/.bash-my-colors` and change the first 4-6 lines to your desired colors.  E.g. change the word `BIGreen` to `BICyan`, etc..  Refer to `~/etc/.bash-colours` to see the common names of which colors are available. 

3. Its ready to run, you can exit and log back into your user, or manally source .bashrc_custom.  
-  If you have any problems with ssh-agent when you first start using the script, you can comment the line `. ~/etc/ssh-agent-bootstrap` on `.bash-rc-global`
- If you have any problmes with .git prompt, you can comment the line `. ~/etc/.git-prompt` on `.bash-profile-global`
- if you see a bunch of color characters instead of a proper terminal command, or are having unexpected results, make sure you are running BASH.  If your not sure, you can enter BASH by typing in `bash` in your terminal first. If this resolves it then you need to add /bin/bash as  yaur shell on /etc/pwd, you may have it set to /bin/sh or something else. 

## Notes
- some of the more useful aliases
  - `l` which is (`ls-la`), `h` (`cd ~`), `u` (`cd ..`), `gd` (`git diff`), `gsh` (`git status`), `gr` (`git remote -v`)
  - Read the `~/etc/.bash-alias` file to see them all, and add your aliases to this file. 
- If you use other terminal colors, e.g.  mac terminal with a profile that changes colors, then the defaul colors might clash.  There is an installation option that prompts you, asking if you want to use the recommended default colors.  You would want to select NO for this question. When you select NO, the entry on `~/etc/.bash-profile-global` that sources `~/etc/.bash-my-colors` will be automatically commented, and the entry `~/etc/.bash-my-colors-plain` is uncommented.  The `.bash-my-colors-plain` is still in a rudimentary form, and might be cleaned up at a later time. 
- See `.vimrc` to adjust your vim colorscheme
- If your a `gnu screen` user
  - To use the `gnu screen` layout, you will need a later version of screen, e.g. `4.06.02`. Compile the binary using `make`, place into your bin dir, and add an alias, or `make` then install the latest version of it onto your stack as `sudo`. The new custom config will work right away, use `screen -RA` to launch, and `ctrl + a d` to detach.
  - If you opt for the global `profile.d` installation option, the careful thing to do, as with any new `profile.d` script, is to restart the server after the file (or symlink) is in place, to ensure nothing behind the scenes (e.g. `nologin`, or non interactive) triggers it (`bashetize.sh` has been updated to check that its interactive to prevent this.), and that all your services have started correctly (`sudo chkconfig`, `sudo systemctl status -a`, `sudo journalctl -xn`, etc..).  You can also watch your system logs, e.g. `sudo tail -n 100 /var/log/messages` (The script uses `logger` to log some info there).  
- For other distros, you will know if it runs or not by testing the `install.sh` script on your distro.  If you choose to take the lesser recommended automated method of installation (`profile.d` method) you will want to make sure you have logger installed `which logger`, and verify the path vars, etc.. 

## known issues
- When the directory `.ssh/cm_socket`, specified on `.ssh/config`, is copied, if the owner is other than the one who runs the copy command, `rsync` complains that it cand read into the directory.  This is acceptable because its empty anyway, and its only that dir which is needed, which does successfuly copy anyway. This happends because the `cm_socket` dir needs to be set to `700`, so for now it is `700`.  At a later time the `cm_socket` can be set to `755`, or `775`, then the `rsync` command, or another command issued, can be adjusted to set it to `700` after the copy.   
