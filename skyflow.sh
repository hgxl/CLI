#! /bin/sh
#echo "Hello world !"

# Variables

#echo $BASH
#echo $BASH_VERSION
#echo $HOME
#echo $PWD

#name='Franck'

#echo "$name"

# Input

#echo "Enter names : "
#read name1 name2
#echo "Names are : $name1, $name2"

#read -p "Nom sur une ligne : " name3
#read -sp "Enter password : " myPass

#echo "Enter name as array : "
#read -a names
#echo "Names : ${names[0]}, ${names[1]}"

export SKYFLOW_DIR=$HOME/'.skyflow'
export SKYFLOW_CACHE_DIR=$SKYFLOW_DIR/'cache'
export SKYFLOW_VERSION='1.0.0'
export SKYFLOW_GITHUB_URL='https://github.com/franckdiomande/Skyflow-cli.git'

function printError(){
    echo -e '\033[0;31m Skyflow error: '$1' \033[0m'
}

function printSuccess(){
    echo -e '\033[0;92m ✓ '$1' \033[0m'
}

function clone(){
    if [ ! -d $SKYFLOW_CACHE_DIR ]; then
    	git clone $SKYFLOW_GITHUB_URL $SKYFLOW_CACHE_DIR
	fi
}

function install(){

    componentDir=$SKYFLOW_CACHE_DIR/'component/'$1

    if [ ! -d $componentDir ]; then
    	printError $1' component not found!'
    	exit 1
	fi

    printSuccess $1' component was successfully installed!'
    exit 0
}

# Create skyflow directory for current user
if [ ! -d $SKYFLOW_DIR ]; then
    mkdir $SKYFLOW_DIR
fi

clone

case $1 in
        "install")
            install $2
            ;;
        *)
            echo "J'te connais pas, ouste !"
            ;;
esac

#install 'docker-entrypoint'




