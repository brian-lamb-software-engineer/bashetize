# /etc/profile.d/bashetize.sh stuff
# intended to add custom bash configs to root and users

# TODO add functionality if .bashrc.custom exists already, check if it has 
#  the lines on it that source the basehtizez files, if not, then append 
#  that info, and THEN check if etc files exist, otherwise copy in etc files, as 
#  opposed to the way it is now where they are copied first. 
# FORNOW just assuming bashetize wasnt installed if .bashrc.custom doesnt 
#  exist, and going ahead with the install. 
#
# TODO, if on a non puppet machine, the system will not include the 
#  .bashrc.custom file, so you will need to add that functionality that will 
#  auto source it from yoru .bashrc. Infact, will probably need that functionaliy 
#  anyway in order for this to work. 

# in puppet
#file { "/etc/profile.d/bashetize.sh":
#    ensure => present,
#        source => ...[whatever's appropriate for your setup]...,
#            ...
#}

#DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null && pwd )"
DIR=/usr/local/src/bashetize;
BASHRC_CUSTOM=.bashrc.custom
ETCFILES=~/etc
PROFILE_FILE=.bash-profile-global
USER_BASHETIZE_PATH=$DIR/userhome;
USER_BASHETIZE_BASHRC_CUSTOM=${USER_BASHETIZE_PATH}/${BASHRC_CUSTOM};
USER_BASHETIZE_ETCFILES=${USER_BASHETIZE_PATH}/etc;
ROOT_BASHETIZE_PATH=$DIR/root;
ROOT_BASHETIZE_BASHRC_CUSTOM=${ROOT_BASHETIZE_PATH}/${BASHRC_CUSTOM};
ROOT_BASHETIZE_ETCFILES=${ROOT_BASHETIZE_PATH}/etc;

function logEntry {
    # There should be no entry for a user that has no bash, e.g. whose shell is /sbin/nologin, etc..,  since this is running from profile.d
    echo "/etc/profile.d/bashetize.sh triggered by $(whoami)" | logger >> /dev/null;
}

function promptUser {
    echo
    #echo "No .bashrc.custom file was found"
    echo "This is the first login since a recent update incorporating Bashetize, or this is a new user."


    # prompt user first to install 
    while true; do 
            read -p "Do you want to install Bashetize(custom bash files) now? (recommended) (y/n)?" yn
        case $yn in
            [Yy]* )
                echo;  
                echo "$(whoami) installing Bashetize." | logger >> /dev/null;

                #install it
                # TODO how do you redirect only errors, but not the read -p line to the log.  this is currently doing both. 
                installBashetize 2> >(logger >&2);

                break;;
            [Nn]* )
                echo "Install canceled, exiting!"
                echo;
                echo "$(whoami) opted out." | logger >> /dev/null;
                break;;
            * ) echo "Please answer y or n!";;
        esac
    done
}

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
                    echo "$(whoami) chose default color scheme." | logger >> /dev/null;

                    break;;

                 [Nn]* )
                    echo "$(whoami) chose the plain color scheme." | logger >> /dev/null;

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

function installBashetize {
    # assuming since there was any custom bash config file, then we need to install.
    #root check
    #if [ `whoami` != root ]; then
    if [[ $EUID -ne 0 ]]; then
        #Is not root, set vars to user files
        BASHETIZE_PATH=$USER_BASHETIZE_PATH;
        BASHETIZE_BASHRC_CUSTOM=$USER_BASHETIZE_BASHRC_CUSTOM
    else
        # is root, set vars to root files
        BASHETIZE_PATH=$ROOT_BASHETIZE_PATH;
        BASHETIZE_BASHRC_CUSTOM=$ROOT_BASHETIZE_BASHRC_CUSTOM
    fi

    # Install Bashetize if library located
    if [ -f ${BASHETIZE_BASHRC_CUSTOM} ]; then
        
        echo "Now instaling Bashetize"
        sleep 1;
        
        #install the custom bash file
        # rsync needs the trailing slash on copy dir path
        #rsync -rl --no-perms --ignore-existing --exclude=".ssh/cm_socket/.gitignore" ${BASHETIZE_PATH}/ ~;
        rsync -vrla --no-o --ignore-existing --exclude=".ssh/cm_socket/.gitignore" ${BASHETIZE_PATH}/ ~;

        echo "Bashetize installed."
        echo
        sleep 1;

        #root check
        #if [ `whoami` != root ]; then
        if [[ $EUID -ne 0 ]]; then
            #Is not root, set vars to user files
            offerUserColorChoice;
        fi
        echo "$(whoami) install completed." | logger >> /dev/null;

        # now source the custom bash file out of the users dir
        . ~/${BASHRC_CUSTOM};
        echo "$(whoami) sourced ~/${BASHRC_CUSTOM}." | logger >> /dev/null;

    else 
        echo "Bashetize custom bash file (${BASHETIZE_BASHRC_CUSTOM}) not found, cant install anything, ignoring.";
        echo "$(whoami) source bash file ${BASHETIZE_BASHRC_CUSTOM} not found, aborting." | logger >> /dev/null;
    fi
    
    #TODO will not need to source the custom bash file from .bashrc
    #...
}

#MAKE SURE NOT pe-postgresql, puppet was having problems because /etc/init.d/pe-postgres service triggers /bin/bash so this runs
if [[ ! "$(whoami)" =~ ^pe ]]; then
    echo "Allowing user $(whoami)" | logger >> /dev/null;
    #TODO consider running this only if user group is causeway
    # copy in .bashrc.custom
    if [ ! -f ~/${BASHRC_CUSTOM} ]; then
        #before we install, log entry and prompt the user
        logEntry;
        promptUser;
    #else
        #echo ".bashrc.custom found";
        #  sourcing.
	      #. ~/${BASHRC_CUSTOM}
        #sleep 1;
        # TODO check if this file contains the includes for the custom configs in etc/ before
    fi
else
    # Leave uncommented only for testing
    echo "Bypassing user $(whoami)" | logger >> /dev/null;
fi
