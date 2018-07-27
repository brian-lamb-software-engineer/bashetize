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

# if dir existsthe files
if [ -f $BASHETIZE_PATH/.bashrc.custom ]; then
    rsync -vrlp --no-perms --ignore-existing --exclude ".ssh/cm_socket/.gitignore" $BASHETIZE_PATH/ ~/
    echo "The files were installed, dont forget to check that .bashrc.custom is sourced from .bashrc"
else
        echo "Could not locate custom bash file at $BASHETIZE_PATH/.bashrc.custo.  Did you run the install script from the correct location?  If so, in the script is BASHETIZE_PATH var set correctly?"
    
        #TODO add source of .bashrc.custom if doesnt exists, to .bashrc
fi
