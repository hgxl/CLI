#! /bin/sh

#source ././../../helper.sh
source $HOME/.skyflow/helper.sh

export SKYFLOW_DOCKER_VERSION="1.0.0"
export SKYFLOW_DOCKER_DIR=$SKYFLOW_DIR/component/docker

function findDockerComposeFile()
{
        if [ -d docker ] && [ ! -f docker-compose.yml ]; then
            cd docker
        fi

        if [ ! -f docker-compose.yml ]; then
            skyflowHelperPrintError "docker-compose.yml file not found"
            exit 1
        fi
}

#
# This function uses docker.ini information to:
# - create document root directory
# - create directory index file
# - add server name to /etc/hosts file
#
function dockerHelperOnContainerFinish()
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
    sudo sh -c "echo -e 127.0.0.1    $serverName >> /etc/hosts"
    skyflowHelperPrintSuccess "'$serverName' added to your hosts file."
    echo -e "\033[0;94mAfter 'skyflow-docker up' command, go to \033[4;94m$serverName:$containerPort\033[0m"
}

