#!/bin/bash
# isntalls the files, using rsync, ignoring any existing files, not changing any perms, and ignoring specific git files
#first does a very basic check for a custom dir name.  Make sure you run this from the package root

ETCFILES=~/etc
PROFILE_FILE=.bash-profile-global

function offerUserColorChoice {
        echo "
... Bashetize terminal colors will now be applied. If you
    use a terminal e.g. terminal, iterm, iterm2,  with a 
    profile that has other than black (or dark) background, 
    or to where you might NOT be able to see the default 
    bashetize font color, please iniitially set your 
    profile's background to a dark color (midnight blue,
    deep ocean blue, black, charcoal, etc..)  and your
    font color to default, so that the initial colors can
    come through.  

...  You would then want to answer yes, to use the default
     colors. 

... After this, you can fine tune your font colors on
     .bash-my-colors, and finetune your background. 
    
... If for some reason the default color does not work for
    your setup, you can switch it to plain by either re-
    running this install and selecting the plain option,
    or by uncommenting the line that sources 
    ./etc/.bash-my-colors-plain on 
    ~/etc/.bash-profile-global, and comment the line that
    sources ~/etc/bash-my-colors. 

... Cancelling now will also use the default and will cause you to
    need to exit and log back in before re-running." 

        while true; do 
          read -p "... Please make a choice (n) for plain, (y) for recommended default
...  Do you want to use the default? (y/n)?" yn 2>/dev/tty

            case $yn in
                [Yy]* )
                    # do nothing, default is already being used
                    echo "... Time: $(/bin/date). $(whoami) chose default color scheme." | logger >> /dev/null;

                    break;;

                 [Nn]* )
                    echo "... Time: $(/bin/date). $(whoami) chose the plain color scheme." | logger >> /dev/null;

                    echo "... Using the plain file."
                    echo "... To test the colored PS1 (recommended), see ~/etc/.bash-profile-global!"; 
                    echo;

                    # to uncomment
                    EDITFILE_REGEX='^#.*my-colors-plain'; 
                    sed -i "/${EDITFILE_REGEX}/s/^#//" ${ETCFILES}/${PROFILE_FILE}

                    # to comment non plain file
                    EDITFILE_REGEX='.*my-colors$'; 
                    sed -i "/${EDITFILE_REGEX}/s/^/#/g" ${ETCFILES}/${PROFILE_FILE}

                    break;;
                * ) echo "... Please answer y or n!";;
            esac
        done
}


## 
# first make sure submodules are init, since this is a common mistake, but a needed dependency.  With they arent init, its pretty easy to update --init afterwords, and run the install again safely. 
git submodule update --init

#root check
#if [ `whoami` != root ]; then
if [[ $EUID -ne 0 ]]; then
    #Is not root, set vars to user files
    BASHETIZE_PATH=./userhome
    offerUserColorChoice;
else
    #is root
    BASHETIZE_PATH=./root
fi

# if .bashrc.custom exists, ready to copy install the files
if [ -f $BASHETIZE_PATH/.bashrc.custom ]; then
    #  UPDATE CODE

    #PREP1  dircolors adjustments
    # due to a recent update, .dircolors was changed, we need to remove the old code
    # if .dircolors is a directory, then its the old setup, its now file
    if [ -d ~/.dircolors ]; then
        # final check for an expected file
        if [ -f ~/.dircolors/dircolors.256dark ]; then
            read -p "... Due to a recent update, your ~/.dircolors directory, will be renamed to ~/dircolors.old.  Please cancel to backup if you have customized anything in there"
            mv ~/.dircolors ~/dircolors.old
            echo "... will also deprecate dircolor entry from your ~/etc/.bash-profile-global and ~/etc/.bash-alias, and leave backups with a .old extension"
            # remove the former condition that eval'd the template theme
            sed -i.old '/^# ~..dircolors.themefile/,+3d' $ETCFILES/.bash-profile-global;
            # remove the former condition that eval'd dircolors, and set alias's
            sed -i.old '/^.\?if \[ -x \/usr\/bin\/dircolors ];/,/^.\?fi/d' $ETCFILES/.bash-alias
            # add sourcing of .dircolors to .bash-colours
            sed -i.old 's/^#.bash_colours/& \
            \
            if [ -f ~\/.dircolors ]; then\
                . ~\/.dircolors\
            fi/' ~/etc/.bash-colours
        else
            echo "... ~/.dircolors was found to be a directory, but didnt recognize the files into it.  In order for your dircolors files to install correctly backup your .dircolors, and create an empty ~/.dircolors folder"
        fi
    fi

    #PREP2 screen layout adjustments
    if [ -f ~/etc/.screen_layout ]; then
        EDITFILE_REGEX='^term.*screen-256color'; 
        sed -i -e "s/${EDITFILE_REGEX}/term xterm-256color/g" ${ETCFILES}/.screen_layout
    fi

     #PREP3 lets remove more .bash files, its becoming increasingly common to update the repo, and reinstall to replace updated bash updates.  The most common file a user will want to keep is the .bash-my-colours, so we will ignore that file atleast.  
    while true; do 
      echo
      echo "
... It's recommended you replace the installation files.
... Anwsering yes to all is basically a reinstall.

... You will now be prompted to replace each file
     collection from a previous installation where you
     can either skip, or continue for that file 
     collection. Answer yes, if you know you dont have
     any modifications on a file in that collection.  If
     you did make modifications to bashetize files, you
     can back that file up, before answering yes and
     continuing. Once complete, you can carry your
     edits into to the newly installed files.

... If you have not made any edits, simply replace 
    them all"

      read -p "
... Do you want to remove all ~/etc/.bash* configurations,
    except .bash-my-colors for replacement 
    (y) replace etc/.bash* files, (n) will not replace?" yn 2>/dev/tty
      case $yn in
        [Yy]* )
          echo "... removing all ~/etc/.bash* files excluding .bash-my-colours"
          find ~/etc/.bash* ! -name ".bash-my-colors" -type f -exec rm -f {} +
          break;;
        [Nn]* )
          break;;
        * ) echo "... Please answer y or n!";;
      esac
    done

     while true; do 
      read -p "... Do you want to remove all ~/etc/.screen configuration for
      replacement? note this will not remove ~/.screen* (y or n)" yn 2>/dev/tty
      case $yn in
        [Yy]* )
          find ~/etc/.screen* -type f -exec rm -f {} +
          break;;
        [Nn]* )
          break;;
        * ) echo "... Please answer y or n!";;
      esac
    done

    while true; do 
      read -p "... Do you want to remove all ~/(.)dircolor* and ~/etc/(.)dircolor* for replacement?" yn 2>/dev/tty
      case $yn in
        [Yy]* )
          find ~/etc/.dircolor* -exec rm -rf {} +
          find ~/etc/dircolor*  -exec rm -rf {} +
          find ~/.dircolor*     -exec rm -rf {} +
          find ~/dircolor*      -exec rm -rf {} +
          break;;
        [Nn]* )
          break;;
        * ) echo "... Please answer y or n!";;
      esac
    done
 
    while true; do 
      read -p "... Do you want to remove .git-prompt for replacement?" yn 2>/dev/tty
      case $yn in
        [Yy]* )
          rm -f ~/etc/.git-prompt   
          break;;
        [Nn]* )
          break;;
        * ) echo "... Please answer y or n!";;
      esac
    done

    while true; do 
      read -p "... Do you want to remove .bashrc.custom for replacement?" yn 2>/dev/tty
      case $yn in
        [Yy]* )
            rm -rf ~/.bashrc.custom
          break;;
        [Nn]* )
          break;;
        * ) echo "... Please answer y or n!";;
      esac
    done

    while true; do 
      read -p "... Do you want to remove .vim* for replacement?" yn 2>/dev/tty
      case $yn in
        [Yy]* )
        rm -rf ~/.vim* 
        #we are now getting this git file manually
        #https://raw.githubusercontent.com/tpope/vim-pathogen/master/autoload/pathogen.vim
        wget -P ~/.vim/autoload https://raw.githubusercontent.com/tpope/vim-pathogen/master/autoload/pathogen.vim

          break;;
         [Nn]* )
          break;;
        * ) echo "... Please answer y or n!";;
      esac
    done

    # INSTALL FILES
    rsync -vrlp --no-perms --ignore-existing --exclude ".ssh/cm_socket/.gitignore" $BASHETIZE_PATH/ ~/
    echo "... The files were installed!  You can exit and relogin for terminal changes to change effect."
    echo "... Alternatively, you can open a new terminal to test that it is working as expected. "
    echo "... The default settings should be good, but you can comment any ~/etc/.bash*global includes to fine tune what is loaded if you have any issues with any of the addons." 
    echo "... Comment the include on .bashrc.custom to stop running bashetize."
    echo "... Enjoy a sigh of relief, things just got easier on the terminal.  Be sure to look up and try some of the new alias's.  Dont forget to update your ~/.gitconfig username"

    if [ ! -f ~/.bashrc ]; then
        touch ~/.bashrc
    fi

    # POST PREP 1 source .bashrc.custom from .bashrc
    # add source line, if not already there
    if ! grep -q ".bashrc.custom" ~/.bashrc; then
       # echo "... skipping adding .bashrc.custom, since its found to exist!"
    #else
        echo ".. adding .bashrc.custom your .bashrc"
        echo "
# Dont remove this entry
# This file is used in place of .bashrc so puppet and otherconfig mgmnt tools  will overwrite any entry on .bashrc except the include for .bashrc.cusom, so we put all our customization downstream of here
# See ~/etc/* for the possible customizations on this, or see the bashetzie readme. 
if [ -f ~/.bashrc.custom ]; then
    . ~/.bashrc.custom
fi" >> ~/.bashrc;

    fi
   
    #CANT GET AUTO SOURCING TO WORK YET HERE
    #lets source this file, need to do this before handing control over to the scripot
    #BASH_ENV="$HOME/.bashrc.custom" "$HOME/bin/auto-ssh-id"
    #~/.bashrc.custom

    #echo "... Dont forget to check that .bashrc.custom is sourced from .bashrc"

else
        echo "... Could not locate custom bash file at $BASHETIZE_PATH/.bashrc.custom.  Did you run the install script from the correct location?  If so, in the script is BASHETIZE_PATH var set correctly?"
fi

