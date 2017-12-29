#! /bin/sh

#source ././../../../../helper.sh
source $HOME/.skyflow/helper.sh

#source ././../../helper.sh
source $HOME/.skyflow/component/docker/helper.sh

function skyflowDockerOnContainerInit()
{
    local container=empty

    # Copy docker-compose.yml file
    if [ -f $SKYFLOW_DOCKER_DIR/container/$container/docker-compose.yml ]; then
        cp $SKYFLOW_DOCKER_DIR/container/$container/docker-compose.yml docker-compose.yml
    fi

}

function skyflowDockerOnContainerProgress()
{
    echo "$2"
}

function skyflowDockerOnContainerFinish()
{
    skyflowHelperPrintInfo "You have created an empty container. Use the 'skyflow-docker use <composer_name>' command to add containers"
}
