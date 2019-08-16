#!/bin/bash
# isntalls the files, using rsync, ignoring any existing files, not changing any perms, and ignoring specific git files
#first does a very basic check for a custom dir name.  Make sure you run this from the package root

ETCFILES=~/etc
PROFILE_FILE=.bash-profile-global

function offerUserColorChoice {
        echo "Your PS1 colors will now be customized. If you use a mac terminal with profiles that contain
        other than black(or dark) background, or to where you might NOT able to see the default
        green font, then you will want to use the plain color file. It's recommended that you 
        only use the plain color file if your sure you need this."
        echo  
        echo "The default color can easily be switched to plain by going to ~/etc/.bash-profile-global
        and uncomment the line that sources ./etc/.bash-my-colors-plain, and comment the line that
        sources ~/etc/bash-my-colors.
        (cancelling now will also use the default and will cause you
        to need to exit and log back in, so please make a choice)
        (n) for plain, (y) recommended default"

        sleep 1;

        while true; do 
                read -p "Do you want to use the default? (y/n)?" yn 2>/dev/tty

            case $yn in
                [Yy]* )
                    # do nothing, default is already being used
                    echo "Time: $(/bin/date). $(whoami) chose default color scheme." | logger >> /dev/null;

                    break;;

                 [Nn]* )
                    echo "Time: $(/bin/date). $(whoami) chose the plain color scheme." | logger >> /dev/null;

                    echo "Using the plain file."
                    echo "To test the colored PS1 (recommended), see ~/etc/.bash-profile-global!"; 
                    echo;

                    # to uncomment
                    EDITFILE_REGEX='^#.*my-colors-plain'; 
                    sed -i "/${EDITFILE_REGEX}/s/^#//" ${ETCFILES}/${PROFILE_FILE}

                    # to comment non plain file
                    EDITFILE_REGEX='.*my-colors$'; 
                    sed -i "/${EDITFILE_REGEX}/s/^/#/g" ${ETCFILES}/${PROFILE_FILE}

                    break;;
                * ) echo "Please answer y or n!";;
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
    # due to a recent update, .dircolors was changed, we need to remove the old code
    # if .dircolors is a directory, then its the old setup, its now file
    if [ -d ~/.dircolors ]; then
        #one final check for an expected file
        if [ -f ~/.dircolors/dircolors.256dark ]; then
            read -p "Due to a recent update, your ~/.dircolors directory, will be renamed to ~/dircolors.old.  Please cancel to backup if you have customized anything in there"
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
            echo "~/.dircolors was found to be a directory, but didnt recognize the files into it.  In order for your dircolors files to install correctly backup your .dircolors, and create an empty ~/.dircolors folder"
        fi

    fi

    if [ -f ~/etc/.screen_layout ]; then
        EDITFILE_REGEX='^term.*screen-256color'; 
        sed -i -e "s/${EDITFILE_REGEX}/term xterm-256color/g" ${ETCFILES}/.screen_layout
    fi

    rsync -vrlp --no-perms --ignore-existing --exclude ".ssh/cm_socket/.gitignore" $BASHETIZE_PATH/ ~/
    echo "The files were installed"




    if [ ! -f ~/.bashrc ]; then
        touch ~/.bashrc
    fi

    # add source line, if not already there
    if ! grep -q ".bashrc.custom" ~/.bashrc; then
       # echo "skipping adding .bashrc.custom, since its found to exist!"
    #else
        echo ".. adding .bashrc.custom your .bashrc"
        echo "
# Dont remove this entry
# This file is because puppet will overwrite any entry on .bashrc except the include for .bashrc.cusom, so we put all our customization downstream of here
# See ~/etc/* for the possible customizations on this, or see the bashetzie readme. 
if [ -f ~/.bashrc.custom ]; then
    . ~/.bashrc.custom
fi" >> ~/.bashrc;

    fi
   
    #CANT GET AUTO SOURCING TO WORK YET HERE
    #lets source this file, need to do this before handing control over to the scripot
    #BASH_ENV="$HOME/.bashrc.custom" "$HOME/bin/auto-ssh-id"
    #~/.bashrc.custom

    #echo "Dont forget to check that .bashrc.custom is sourced from .bashrc"

else
        echo "Could not locate custom bash file at $BASHETIZE_PATH/.bashrc.custo.  Did you run the install script from the correct location?  If so, in the script is BASHETIZE_PATH var set correctly?"
fi

