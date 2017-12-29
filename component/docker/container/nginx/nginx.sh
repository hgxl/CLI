#! /bin/sh

#source ././../../../../helper.sh
source $HOME/.skyflow/helper.sh

#source ././../../helper.sh
source $HOME/.skyflow/component/docker/helper.sh

function skyflowDockerOnContainerInit()
{
    local container=nginx

    # Copy configuration files
    if [ -d $SKYFLOW_DOCKER_DIR/conf/$container ]; then
        cp -r $SKYFLOW_DOCKER_DIR/conf/$container conf/$container
    fi

    # Copy docker-compose.yml file
    if [ -f $SKYFLOW_DOCKER_DIR/container/$container/docker-compose.yml ]; then
        cp $SKYFLOW_DOCKER_DIR/container/$container/docker-compose.yml docker-compose.yml
    fi

    # Copy php configuration files
    cp -r $SKYFLOW_DOCKER_DIR/conf/php conf/php
    if [ -f conf/php/conf.d/.gitignore ]; then
        rm conf/php/conf.d/.gitignore
    fi

    # Copy extra configuration files
    cp -r $SKYFLOW_DOCKER_DIR/extra/php extra/php
    if [ -f extra/php/modules/.gitignore ]; then
        rm extra/php/modules/.gitignore
    fi

}

function skyflowDockerOnContainerProgress()
{
    local container=nginx

    local value=$2

    if [ "$1" == "application.name" ]; then
        # Lower upper
        value="$2" | tr '[:upper:]' '[:lower:]'
    fi

    if [ -f conf/$container/conf.d/default.conf ]; then
        sed -i "s/{{ *$1 *}}/$value/g" conf/$container/conf.d/default.conf
    fi

    echo "$value"
}

function skyflowDockerOnContainerFinish()
{
    dockerHelperOnContainerFinish
}
