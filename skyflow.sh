#! /bin/sh
##! /bin/bash

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

export SKYFLOW_DIR=$HOME/.skyflow
export SKYFLOW_CACHE_DIR=$SKYFLOW_DIR/cache
export SKYFLOW_VERSION="1.0.0"
export SKYFLOW_GITHUB_URL="https://github.com/franckdiomande/Skyflow-cli.git"

author="Skyflow Team - Franck Diomandé <fkdiomande@gmail.com>"
versionMessage="Skyflow CLI version $SKYFLOW_VERSION"
docFile="$SKYFLOW_DIR/skyflow.ini"

function init()
{
    # Create skyflow directory for current user
    if [ ! -d $SKYFLOW_DIR ]; then
        mkdir $SKYFLOW_DIR
    fi

    if [ ! -d $SKYFLOW_DIR/component ]; then
        mkdir $SKYFLOW_DIR/component
    fi

    case $1 in
        "-f")
            if [ -d $SKYFLOW_CACHE_DIR ]; then
                rm -rf $SKYFLOW_CACHE_DIR
            fi
        ;;
    esac

    if [ ! -d $SKYFLOW_CACHE_DIR ]; then
    	git clone $SKYFLOW_GITHUB_URL $SKYFLOW_CACHE_DIR
    	rm -rf $SKYFLOW_CACHE_DIR/.git
	fi

	cp $SKYFLOW_CACHE_DIR/skyflow.ini $SKYFLOW_DIR/skyflow.ini
	cp $SKYFLOW_CACHE_DIR/helper.sh $SKYFLOW_DIR/helper.sh
	sudo chmod +x $SKYFLOW_DIR/helper.sh
}

function install()
{
    componentCacheDir=$SKYFLOW_CACHE_DIR/component/$1

    # Check if component exists
    if [ ! -d $componentCacheDir ] || test -z $1; then
    	./helper.sh "printError" "$1 component not found"
    	exit 1
	fi

	# Exit if component already exists
    if [ -d $SKYFLOW_DIR/component/$1 ] && [ -f /usr/bin/skyflow-$1 ]; then
    	./helper.sh "printInfo" "$1 component is already installed"
    	exit 0
	fi

    # Install component
	cp -R $componentCacheDir $SKYFLOW_DIR/component/$1

    # Install binary
    sudo cp $SKYFLOW_CACHE_DIR/bin/skyflow-$1.sh /usr/bin/skyflow-$1
    sudo chmod +x /usr/bin/skyflow-$1

    ./helper.sh "printSuccess" "$1 component was successfully installed!"
}

function remove()
{
    componentCacheDir=$SKYFLOW_CACHE_DIR/component/$1

    # Check if component exists
    if [ ! -d $componentCacheDir ] || test -z $1; then
    	./helper.sh "printError" "$1 component not found"
    	exit 1
	fi

    if [ -d $SKYFLOW_DIR/component/$1 ]; then
    	rm -rf $SKYFLOW_DIR/component/$1
	fi

	if [ -f /usr/bin/skyflow-$1 ]; then
    	sudo rm /usr/bin/skyflow-$1
	fi

    ./helper.sh "printSuccess" "$1 component was successfully removed!"
}

init

case $1 in
    "install")
        install "$2"
    ;;
    "remove")
        remove "$2"
    ;;
    "init")
        init "-f"
    ;;
    "update")
        init "-f"
    ;;
    "-h")
        ./helper.sh "-h" "Skyflow CLI" "$author" $docFile
    ;;
    "--help")
        ./helper.sh "-h" "Skyflow CLI" "$author" $docFile
    ;;
    "-v")
        ./helper.sh "-v" "$versionMessage" "$author"
    ;;
    "--version")
        ./helper.sh "-v" "$versionMessage" "$author"
    ;;
    *)
        help
    ;;
esac

exit 0
