!/bin/sh

#  simplecontrol.sh
#  kx-project
#
#  Created by Pietro Caruso on 10/03/17.
#

#files and dirs variables:
#the path to the kext package when instlled
FILE="/System/Library/Extensions/kXAudioDriver.kext"
#shotcut to the current directory name
CDIR="$( dirname "$0" )"
#the path to the kext package before installation
CKEXT="$CDIR/kXAudioDriver.kext"

#change this to use a different return charachter
n="\n"

#used for menù messages
error=""

#because we want to reuse the help function many times and the $1 can't be changed, we put his value in another variable
args="$1"

#this funcion manages the the main script functionalityes
help(){
#this variable is used later to send commands to the commands management part
command=""
#if there are argumets manages them instead of showing the menù
if [ "$args" != "" ]; then
    #manages all the arguments and then assigns a value to the command variable so the action can be executed
    case "$args" in
        -r | --reload )
            command="r"
        ;;
        -s | --stop )
            command="s"
        ;;
        -l | --load )
            command="l"
        ;;
        -lo | --loadonly )
            command="lo"
        ;;
        -rp | --repairp )
            command="rp"
        ;;
        -f | --fixextcache )
            command="f"
        ;;
        -i | --install )
            command="i"
        ;;
        -u | --uninstall )
            command="u"
        ;;
        -h | --help )
            command="h"
        ;;
        * )
#when the arguments is unknown asks the user if he/she wants to use the script as is without arguments execution or to quit the script, for the answer it uses a case insensitive system, that accepts yes (y) no (n) and exits (e) no and exit does the same thing
            sudo printf "invalid arguments: Do you want to access the utility withouth arguments? (y, n)"
            read answer
            case "$answer" in
                [yY] | [yY][Ee][Ss] )
                    command="h"
                ;;
                [nN] | [nN][Oo] | [eE] | [eE][xX][iI][tT] )
                    command="e"
                ;;
                * )
#of couse if the user inserts an invalid answer the help function will be called, and because of the actual value of args asks again this question, but it also says to the user that the text is invalid
                    sudo echo "! invalid answer"
                    help
                ;;
            esac
        ;;
    esac
else
    #if there are not arguments shows the option menù where he/she can do some actions, here you can also find commands definitions
#to make averything faster, the all text is put inside a single variable and then showed to the user using a single printf funcion that also executes the return characters, the text is assigned using a lot of lines to make easier to recreate his look in the terminal inside the code editor
    c=""
    c="$c$n============ KX AUIDIO DRIVER SIMPLE CONTROL UTILTY ============"
    if [ "$error" != "" ]; then
        c="$c$n previous operation results: $error"
    else
        c="$c$n"
    fi
    c="$c$n"
    c="$c$n What do you want to do?"
    c="$c$n"
    c="$c$n     [r]  reload      --- restarts the kext by unloading"
    c="$c$n                          the driver, fixing kext permitions,"
    c="$c$n                          re-loading the kext, and reparing kexts cache"
    c="$c$n     [s]  stop        --- unloads the kext"
    c="$c$n     [sf] stopforced  --- unloads the kext in forced way"
    c="$c$n     [l]  load        --- loads the kext by loading the kext,"
    c="$c$n                          and reparing kexts cache and permitions"
    c="$c$n     [lo] loadonly    --- loads only the kext without repairs"
    c="$c$n     [rp] repairp     --- repairs permitions of the kext"
    c="$c$n     [f]  fixectcache --- processes the cache of all the kexts"
    c="$c$n                          in /System/LIbrary/Extensions"
    c="$c$n     [i]  install     --- goes to the kext installation menù"
    c="$c$n     [u]  uninstall   --- unstalls the kext and his libraries"
    c="$c$n     [h]  help        --- shows this screen with informations"
    c="$c$n     [e]  exit        --- exit from this utility"
    c="$c$n"
#c="$c$n"
#c="$c$n"
    c="$c$n"
    c="$c$n Type here and press enter:"
    c="$c$n"

    sudo printf "$c"
#reads answer
    read commands
#stes the command variable with the input from the user
    command="$commands"
#clears error variable to not show ouputs if there is nothing to output
    error=""
fi
#clear the args variable so when the function will be called again will show the menù insted of directly executing the action specified in arguments
args=""
#sees which is the command the user specified using args or the menù, as whell it uses a case insensitive system
case "$command" in
#for the following statements there is a check to see if the kext is installed, so if not he asks if the user wants to install it

#reload command
    [rR] | [rR][eE][lL][oO][aA][dD] )
        if [ -d "$FILE" ]; then
            unload_forced
            sudo sleep 1
            fixperm
            loadkext
            fixcache

            error="kext reload complete"
        else
            error=""
            install
        fi
    ;;
#stop command, unloads the kext with installation checking
    [sS] | [sS][tT][oO][pP] )
            unload
            error="kext stop complete"
    ;;
#load command
    [lL] | [lL][oO][aA][dD] )
        if [ -d "$FILE" ]; then
            fixperm
            loadkext
            fixcache

            error="kext load complete"
        else
            error=""
            install
        fi
    ;;
#loadonly command
    [lL][oO] | [lL][oO][aA][dD][oO][nN][lL][yY] )
        if [ -d "$FILE" ]; then
            loadkext

            error="kext load only complete"
        else
            error=""
            install
        fi
    ;;
#repair permitions command
    [rR][pP] | [rR][eE][pP][aA][iI][rR][pP] )
        if [ -d "$FILE" ]; then
            fixperm

            error="kext permitions repair complete"
        else
            error=""
            install
        fi
    ;;
#fix external cache command
    [fF] | [fF][iI][xX][eE][xX][tT][cC][aA][cC][hH][eE] )
        if [ -d "$FILE" ]; then
            fixcache

            error="kext cache cleaning complete"
        else
            error=""
            install
        fi
    ;;
#the following commands will not direcly check if the kext is installed or will not check at all, only unistall does
#stop forced stops the kext without checking for the installation, usefoul when there is an instance of the driver that is not in s/l/e
    [sS][fF] | [sS][tT][oO][pP][fF][oO][rR][cC][eE][dD] )
        unload_forced
        error="kext stop forced complete"
    ;;
#exit from the script command
    [Ee] | [eE][xX][iI][tT] )
        sudo echo "bye bye ..."
        bye
    ;;
#install kext command, calls the install function
    [iI] | [Ii][nN][sS][tT][aA][lL][lL] )
        sudo echo
        error=""
        install
    ;;
#unistall kext, checks if the kext is present, if yes unloads and then unistalls it and his libraries and symbols
    [uU] | [uU][nN][iI][nN][sS][tT][aA][lL][lL] )
        sudo echo
        if [ -d "$FILE" ]; then
            sudo echo "kext unistall started ..."
            unload_forced
            removekext
            sudo echo "kext unistall finished"
            error="kext unistalled finished"
        else
            sudo echo "kext already unistalled"
            error="kext already unistalled"
        fi
    ;;
#if the command his help, nothing or ? shows the menù again by re calling the function
    ? | [hH] | "" | [hH][eE][lL][pP] )
        help
    ;;
    * )
#in case of an invalid command, show the menù again with an alert message
        sudo echo "! invalid action, please chose a valid one"
        error="! invalid action ! type a valid command"
        help
    ;;
esac
sudo echo "Process complete"
#when the execution is finished, the function will be executed again, so the user is able to do other stuff if he wants
help
}
#function that manages installiation of the kext, has it's own menù and commands like help function, but here aks only yes, no, help and exit
install(){

    #to make averything faster, the all text is put inside a single variable and then showed to the user using a single printf funcion that also executes the return characters, the text is assigned using a lot of lines to make easier to recreate his look in the terminal inside the code editor
#here you can find also command definitions to understand what they does
    c=""
    c="$c$n============ KX AUIDIO DRIVER SIMPLE CONTROL UTILTY ============"
    if [ "$error" != "" ]; then
        c="$c$n previous operation results: $error"
    else
        c="$c$n"
    fi
    c="$c$n"
    if [ ! -d "$FILE" ]; then
        c="$c$n The kext is missing, do you want to install it?"
    else
        c="$c$n Do you want to install the kext?"
    fi
    c="$c$n"
    c="$c$n     [y]    YES   -- Installs kexts and all the needed libraries"
    c="$c$n"
    c="$c$n     [n]    NO    -- Exit from this menù"
    c="$c$n"
    c="$c$n     [?][h] HELP  -- Shows this screen with command informations"
    c="$c$n"
    c="$c$n     [e]    EXIT  -- Go back"
    c="$c$n"
    c="$c$n"
    c="$c$n"
    c="$c$n"
    c="$c$n"
    c="$c$n"
    c="$c$n"
    c="$c$n"
    c="$c$n" #"$error"
    c="$c$n"
    c="$c$n Type here and press enter:"
    c="$c$n"
#prints the menù
    sudo printf "$c"
#reads user answer
    read option
#set error to nothing
    error=""
#sees which input the user gives, as whell with a case insensitive system
    case "$option" in
        [yY] | [yY][Ee][Ss] )
#if yes does the installation process
            sudo echo "Starting installation ..."

#checks for an existing installation and then unloads and unistalls the existing driver
            if [ -d "$FILE" ]; then
                unload_forced
                removekext
            fi
#checks if needed files for installation are present
            if [ -d "$CKEXT" ] && [ -e "$CDIR/kxctrl" ] && [ -e "$CDIR/edspctrl" ] && [ -e "$CDIR/kXAPI.dylib" ] && [ -d "$CDIR/kXAudioDriver.kext.dSYM" ]; then
#copyes kext, sybmbols and libraries to the final directory
                sudo cp -R "$CDIR/kXAudioDriver.kext" "/System/Library/Extensions"
                sudo cp -R "$CDIR/kXAudioDriver.kext.dSYM" "/System/Library/Extensions"

#fix the permitions for the instaled kext kext
                fixperm

#copies and fix permitions for the libraries
                    sudo cp "$CDIR/kxctrl" /usr/bin
                    sudo cp "$CDIR/edspctrl" /usr/bin
                    sudo cp "$CDIR/kXAPI.dylib" /usr/lib
                    sudo chown root:admin /usr/bin/kxctrl
                    sudo chown root:admin /usr/bin/edspctrl
                    sudo chown root:admin /usr/lib/kXAPI.dylib
                    sudo chmod 0755 /usr/bin/kxctrl
                    sudo chmod 0755 /usr/bin/edspctrl
                    sudo chmod 0755 /usr/lib/kXAPI.dylib

#fixs kext cache for older mac os x versions
                    fixcache
                    sudo echo "installation complete"
                    error="installation complete"
#goes back to main menù of the script
                    help
            else
#if one or more files are missing the installation is not done and cames back to the mein menù of the script

                sudo echo "$CDIR"

                if [ ! -d "$CKEXT" ]; then
                    sudo echo “the kext file is missing”
                fi

                if [ ! -e "$CDIR/kxctrl" ]; then
                    sudo echo “the kxctrl file is missing”
                fi

                if [ ! -e "$CDIR/kXAPI.dylib" ]; then
                    sudo echo “the KXAPI.dylib file is missing”
                fi

                if [ ! -d "$CDIR/kXAudioDriver.kext.dSYM" ]; then
                    sudo echo “the KXAudioDriver.kext.dSYM file is missing”
                fi

                if [ ! -e "$CDIR/edspctrl" ]; then
                    sudo echo “the edspctrl file is missing”
                fi

                error="! installation failed, one or more required files are missing"
                sudo echo "! fail, one of more required files are missing"

                #install
                help
            fi

            #sudo cp -R /kXAudioDriver.kext /System/Library/Extensions
        ;;
#if the aswer is no, comes back to the main menù
        [nN] | [nN][Oo] | [eE] | [eE][xX][iI][tT] )
            help
        ;;
#if help, ? or noting is typed, sows the screen again without any message
        "?" | [hH] | "" | [hH][eE][lL][pP] )
            install
        ;;
#if a text that does not coresponds to any command is inserted shows the menù again with an error message
        * )
            error="! invalid action ! type a valid command"
            install
        ;;
    esac
}
#here are some functions for specific actions
#this unloads a kext that is running, checks also for installation
unload(){
    if [ -d "$FILE" ]; then
        unload_forced
    else
#if the kext is not installed better to not call the unload
        sudo echo "kext not installed, skip unloading ..."
    fi
    sudo sync
}

#this unloads the kext without chcking or installation
unload_forced(){
sudo echo "unloading existing driver..."
sudo sync
sudo kextunload -v "$FILE"
sudo sleep 1
sudo sync
sudo kextunload -q "$FILE"
sudo echo "driver unloading complete"
sudo sync
}
#fixs the permitions for the kext, and libraries
fixperm(){
    sudo echo "fixing permissions..."

    sudo chown root:admin /usr/bin/kxctrl
    sudo chown root:admin /usr/bin/edspctrl
    sudo chown root:admin /usr/lib/kXAPI.dylib
    sudo chmod 0755 /usr/bin/kxctrl
    sudo chmod 0755 /usr/bin/edspctrl
    sudo chmod 0755 /usr/lib/kXAPI.dylib


    sudo chown -R root:wheel "$FILE"
    sudo find "$FILE" -type d -exec /bin/chmod 0755 {} \;
    sudo find "$FILE" -type f -exec /bin/chmod 0644 {} \;
    sudo echo "permission fixing complete"
    sudo sync
}
#loads only the kext
loadkext(){
    sudo echo "loading KEXT..."
    sudo kextutil -ls "/System/Library/Extensions" "$FILE"
    sudo kextutil -v "$FILE"
#sudo kextload -v /System/Library/Extensions/kXAudioDriver.kext
    sudo echo "kext loading complete"
    sudo sync
}

#for older mac os x versions, rebuilds the kext cache
fixcache(){
    sudo echo "processing kext cache..."
    sudo rm -R /System/Library/Extensions.kextcache
    sudo rm -R /System/Library/Extensions.mkext
    sudo touch /System/Library/Extensions
    sudo echo "cache processing complete"
    sudo sync
}
#unistalls kext, libraries and symbols, inlcluding kexts from older versions
removekext(){
    sudo echo "removing existing driver..."
    sudo sudo rm -rf "$FILE"
    sudo sudo rm -rf /System/Library/Extensions/kKXLog.kext
    sudo sync
    sudo echo "removing kext complete"
    sudo echo "removing libraries..."
    sudo rm -rf "/usr/bin/edspctrl"
    sudo rm -rf "/usr/bin/kxctrl"
    sudo rm -rf "/usr/lib/kXAPI.dylib"
    sudo echo "removing libraries complete"
    sudo sync
}
#just a function to call if you want to use the main fuction that is help, but with main name to be more intuitive
main(){
    help
}
#just a function to manage actions when the users quits from the script, but inside of it, before exit, actions to do before the script terminates
bye(){
#put code beetween this two comments



#––––––––––––––––––––––––––––––––––-
exit
}
#the excecution of the script main function and of cores of the all script starts here, in the last line
main
