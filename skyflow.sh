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

function printError()
{
    echo -e "\033[0;31mSkyflow error: "$1" \033[0m"
}

function printSuccess()
{
    echo -e "\033[0;92m✓"$1" \033[0m"
}

function printInfo()
{
    echo -e "\033[0;94m"$1" \033[0m"
}

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
}

function help()
{
    echo
    echo -e "\033[0;96mSkyflow CLI\033[0m\033[0;37m - Franck Diomandé <fkdiomande@gmail.com>\033[0m"

    start=1
    end=100
    for ((i=$start; i<=$end; i++)); do echo -n -e "\033[0;96m-\033[0m"; done

    echo

    while IFS== read command desc
    do
        len=${#command}
        echo -n -e "\033[0;35m$command\033[0m"
        for ((i=1; i<=20-$len; i++)); do echo -n " "; done
        echo -n -e "\033[0;30m$desc\033[0m"
        echo
    done < $SKYFLOW_DIR/skyflow.ini

    echo
}

function version()
{
    echo -e "\033[0;96mSkyflow CLI version $SKYFLOW_VERSION\033[0m"
    echo -e "\033[0;37mSkyflow Team - Franck Diomandé <fkdiomande@gmail.com>\033[0m"
}

function install()
{
    componentCacheDir=$SKYFLOW_CACHE_DIR/component/$1

    # Check if component exists
    if [ ! -d $componentCacheDir ] || test -z $1; then
    	printError $1" component not found"
    	exit 1
	fi

	# Exit if component already exists
    if [ -d $SKYFLOW_DIR/component/$1 ] && [ -f /usr/bin/skyflow-$1 ]; then
    	printInfo $1" component is already installed"
    	exit 0
	fi

    # Install component
	cp -R $componentCacheDir $SKYFLOW_DIR/component/$1

    # Install binary
    sudo cp $SKYFLOW_CACHE_DIR/bin/skyflow-$1.sh /usr/bin/skyflow-$1
    sudo chmod +x /usr/bin/skyflow-$1

    printSuccess $1" component was successfully installed!"
}

function remove()
{
    componentCacheDir=$SKYFLOW_CACHE_DIR/component/$1

    # Check if component exists
    if [ ! -d $componentCacheDir ] || test -z $1; then
    	printError $1" component not found"
    	exit 1
	fi

    if [ -d $SKYFLOW_DIR/component/$1 ]; then
    	rm -rf $SKYFLOW_DIR/component/$1
	fi

	if [ -f /usr/bin/skyflow-$1 ]; then
    	sudo rm /usr/bin/skyflow-$1
	fi

    printSuccess $1" component was successfully removed!"
}

init

case $1 in
    "install")
        install $2
    ;;
    "remove")
        remove $2
    ;;
    "init")
        init "-f"
    ;;
    "update")
        init "-f"
    ;;
    "-h")
        help
    ;;
    "--help")
        help
    ;;
    "-v")
        version
    ;;
    "--version")
        version
    ;;
    *)
        help
    ;;
esac

exit 0
