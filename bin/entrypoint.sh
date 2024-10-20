#!/bin/sh

# arguments: fist is the line to comment, second is the file
# comments should be in this format: #comment 
# comments should not be in this format # comment
commentLine() {
    sed -e "/^$1/ s/^#*/#/" -i $2
}
uncommentLine() {
    sed -e "/^#$1/ s/^#*//" -i $2
}

RED='\033[0;31m'
YELLOW='\033[1;33m'
GREEN='\033[0;32m'
NC='\033[0m' # No Color

echo_red() {
    echo -e "${RED}$1${NC}"
}
echo_yellow() {
    echo -e "${YELLOW}$1${NC}"
}
echo_green() {
    echo -e "${GREEN}$1${NC}"
}

CONFIG_FILE_PATH=/mosquitto/config/mosquitto.conf
PASSWORD_FILE_PATH=/mosquitto/config/password.txt


createAuthConfig() {
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

createPasswordFile() {
    if [ -z "$1" ] || [ -z "$2" ]; then
        echo_red "empty user or password"
        exit 1
    else
        mosquitto_passwd -c -b "$PASSWORD_FILE_PATH" "$1" "$2" && echo_green "######## User created ! ########"

    fi
}

while getopts ":a:u:p:" opt; do
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
