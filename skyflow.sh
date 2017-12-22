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

export SKYFLOW_DIR=$HOME'/.skyflow'
export SKYFLOW_VERSION='1.0.0'
export SKYFLOW_GITHUB_URL='franckdiomande/docker/blob/equimetre'

gitHubUserContent='https://raw.githubusercontent.com'

function init(){
	if [ ! -d $SKYFLOW_DIR ]; then
    	mkdir $SKYFLOW_DIR
    	mkdir $SKYFLOW_DIR/$SKYFLOW_VERSION
	fi

	if [ ! -d $SKYFLOW_DIR/$SKYFLOW_VERSION ]; then
        mkdir $SKYFLOW_DIR/$SKYFLOW_VERSION
	fi
}

init


function install(){
	curl --silent -o "$SKYFLOW_DIR/$SKYFLOW_VERSION/skyflow-$1.sh" "$gitHubUserContent/$SKYFLOW_GITHUB_URL/$1.sh"
}

install 'docker-entrypoint'




