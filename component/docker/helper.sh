#! /bin/sh

export SKYFLOW_DIR=$HOME/.skyflow
export SKYFLOW_DOCKER_VERSION="1.0.0"
export SKYFLOW_DOCKER_DIR=$SKYFLOW_DIR/component/docker

source $SKYFLOW_DIR/helper.sh

function dockerOnContainerFinish()
{
    local applicationName=$(skyflowGetFromIni "docker.ini" "application.name")
    local serverName=$(skyflowGetFromIni "docker.ini" "server.name")
    local directoryIndex=$(skyflowGetFromIni "docker.ini" "directory.index")
    local documentRoot=$(skyflowGetFromIni "docker.ini" "document.root")
    local containerPort=$(skyflowGetFromIni "docker.ini" "container.port")

    # Create document root and directory index
    if [ "$documentRoot" != "." ] && [ ! -d ../$documentRoot ]; then
        mkdir ../$documentRoot
        $SKYFLOW_DIR/helper.sh "printSuccess" "'$documentRoot' directory was created."
    fi

    if [ "$documentRoot" == "." ] && [ ! -f ../$directoryIndex ]; then
        touch ../$directoryIndex
        echo "<h1>$applicationName application is ready!</h1>" >> ../$directoryIndex
        $SKYFLOW_DIR/helper.sh "printSuccess" "'$directoryIndex' file was created."
    fi

    if [ "$directoryIndex" != "." ] && [ ! -f ../$documentRoot/$directoryIndex ]; then
        touch ../$documentRoot/$directoryIndex
        echo "<h1>$applicationName application is ready!</h1>" >> ../$documentRoot/$directoryIndex
        $SKYFLOW_DIR/helper.sh "printSuccess" "'$documentRoot/$directoryIndex' file was created."
    fi

    # Add server name to hosts file
    sudo sh -c "echo -e 127.0.0.1    $serverName >> /etc/hosts"
    $SKYFLOW_DIR/helper.sh "printSuccess" "'$serverName' added to your hosts file."
    echo -e "\033[0;94mAfter 'skyflow-docker up' command, go to \033[4;94m$serverName:$containerPort\033[0m"
}

