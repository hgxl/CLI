#! /bin/bash

#source ././../../helper.sh
source $HOME/.skyflow/helper.sh

export SKYFLOW_DOCKER_VERSION="1.0.0"
export SKYFLOW_DOCKER_DIR=$SKYFLOW_DIR/component/docker

function findDockerComposeFile
{
        if [ -d docker ] && [ ! -f docker-compose.yml ]; then
            cd docker
        fi

        if [ ! -f docker-compose.yml ]; then
            skyflowHelperPrintError "docker-compose.yml file not found"
            exit 1
        fi
}

# This function uses docker.ini information to:
# - create document root directory
# - create directory index file
# - add server name to /etc/hosts file
function dockerHelperOnContainerFinish
{
    local applicationName=$(skyflowHelperGetFromIni "docker.ini" "application.name")
    local serverName=$(skyflowHelperGetFromIni "docker.ini" "server.name")
    local directoryIndex=$(skyflowHelperGetFromIni "docker.ini" "directory.index")
    local documentRoot=$(skyflowHelperGetFromIni "docker.ini" "document.root")
    local containerPort=$(skyflowHelperGetFromIni "docker.ini" "application.port")

    # Create document root and directory index
    if [ "$documentRoot" != "." ] && [ ! -d ../$documentRoot ]; then
        mkdir ../$documentRoot
        skyflowHelperPrintSuccess "'$documentRoot' directory was created."
    fi

    if [ "$documentRoot" == "." ] && [ ! -f ../$directoryIndex ]; then
        touch ../$directoryIndex
        echo "<h1>$applicationName application is ready!</h1>" >> ../$directoryIndex
        skyflowHelperPrintSuccess "'$directoryIndex' file was created."
    fi

    if [ "$directoryIndex" != "." ] && [ ! -f ../$documentRoot/$directoryIndex ]; then
        touch ../$documentRoot/$directoryIndex
        echo "<h1>$applicationName application is ready!</h1>" >> ../$documentRoot/$directoryIndex
        skyflowHelperPrintSuccess "'$documentRoot/$directoryIndex' file was created."
    fi

    # Add server name to hosts file
    sudo sh -c 'printf "127.0.0.1       %s" "$serverName" >> /etc/hosts'
    skyflowHelperPrintSuccess "'$serverName' added to your hosts file."
    printf "\033[0;94mAfter 'skyflow-docker up' command, go to \033[4;94m%s:%s\033[0m" "$serverName" "$containerPort"
}

function skyflowDockerPullConfAndExtraConf
{
    for element in conf extra; do

        if grep -Fxq "$1" $SKYFLOW_DOCKER_DIR/list/$element.ls; then

            if [ ! -f $SKYFLOW_DOCKER_DIR/make/$element/$1.sh ]; then
                mkdir -p $SKYFLOW_DOCKER_DIR/make/$element
                skyflowHelperPullFromRemote "component/docker/make/$element/$1.sh" "$SKYFLOW_DOCKER_DIR/make/$element/$1.sh"
                sudo chmod +x $SKYFLOW_DOCKER_DIR/make/$element/$1.sh
            fi
            # Create directories and get files for selected container
            [ ! -d $SKYFLOW_DOCKER_DIR/$element/$1 ] && $SKYFLOW_DOCKER_DIR/make/$element/$1.sh

        fi

    done
}
