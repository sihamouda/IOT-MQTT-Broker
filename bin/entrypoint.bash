#!/bin/bash


# arguments: fist is the line to comment, second is the file
# comments should be in this format: #comment 
# comments should not be in this format # comment
function commentLine {
    sed -e "/^$1/ s/^#*/#/" -i $2
}
function uncommentLine {
    sed -e "/^#$1/ s/^#*//" -i $2
}

RED='\033[0;31m'
YELLOW='\033[1;33m'
GREEN='\033[0;32m'
NC='\033[0m' # No Color

function echo_red {
    echo -e "${RED}$1${NC}"
}
function echo_yellow {
    echo -e "${YELLOW}$1${NC}"
}
function echo_green {
    echo -e "${GREEN}$1${NC}"
}

CONFIG_FILE_PATH=/mosquitto/config/mosquitto.conf
CONFIG_FILE_PATH=../config/mosquitto.conf
PASSWORD_FILE_PATH=/mosquitto/config/password.txt
PASSWORD_FILE_PATH=../config/password.txt


function createAuthConfig {
    case $1 in 
        false)
            uncommentLine allow_anonymous $CONFIG_FILE_PATH
            commentLine password_file $CONFIG_FILE_PATH
            echo_red "######## Auth configuration: disabled ! ########"
        ;;
        password)
            commentLine allow_anonymous $CONFIG_FILE_PATH
            uncommentLine password_file $CONFIG_FILE_PATH
            echo_yellow "######## Auth configuration: user/password ! ########"
        ;;
        ?)
            echo "Invalid option: $1"
            exit 1
        ;;
    esac
}

function isTLS {
    if [ $1 -eq "true" ];then
        commentLine listener $CONFIG_FILE_PATH
        uncommentLine "listener 8883" $CONFIG_FILE_PATH
        uncommentLine tls_version $CONFIG_FILE_PATH
        uncommentLine cafile $CONFIG_FILE_PATH
        uncommentLine keyfile $CONFIG_FILE_PATH
        uncommentLine certfile $CONFIG_FILE_PATH
        echo_green "######## TLS ACTIVATED ! ########"
    else
        commentLine listener $CONFIG_FILE_PATH
        uncommentLine "listener 1883" $CONFIG_FILE_PATH
        commentLine tls_version $CONFIG_FILE_PATH
        commentLine cafile $CONFIG_FILE_PATH
        commentLine keyfile $CONFIG_FILE_PATH
        commentLine certfile $CONFIG_FILE_PATH
        echo_red "######## TLS DESACTIVATED ! ########"
    fi;
}


function createPasswordFile {
    if [ -z "$1" ] || [ -z "$2" ]; then
        echo_red "empty user or password"
        exit 1
    else
        mosquitto_passwd -c -b "$PASSWORD_FILE_PATH" "$1" "$2" && echo_green "######## User created ! ########"

    fi
}

while getopts ":a:u:p:s:" opt; do
    case ${opt} in
        a)
            createAuthConfig $OPTARG
        ;;
        u)
            USER=$OPTARG
        ;;
        p)
            createPasswordFile $USER $OPTARG
        ;;
        s)
            isTLS $OPTARG
        ;;
        :)
            echo "Option -${OPTARG} requires an argument."
            exit 1
        ;;
        ?)
            echo "Invalid option: -${OPTARG}."
            exit 1
        ;;
    esac
done  

