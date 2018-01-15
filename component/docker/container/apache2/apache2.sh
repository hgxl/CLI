#! /bin/sh

#source ././../../../../helper.sh
source $HOME/.skyflow/helper.sh

#source ././../../helper.sh
source $HOME/.skyflow/component/docker/helper.sh

function skyflowDockerOnContainerInit
{
    local container=apache2

    cp -r $SKYFLOW_DOCKER_DIR/conf/$container/default conf/$container

    export PS3="Select your php version : "
    select php in 5 7 none
    do
        case $php in
          5|7)

            skyflowDockerPullConfAndExtraConf "php"

            # Copy php configuration files
            cp -r $SKYFLOW_DOCKER_DIR/conf/php conf/php

            # Copy extra configuration files
            cp -r $SKYFLOW_DOCKER_DIR/extra/php extra/php

            # Copy container configuration according to php version
            if [ -f $SKYFLOW_DOCKER_DIR/conf/$container/php/conf.d/php$php-module.conf ]; then
                cp $SKYFLOW_DOCKER_DIR/conf/$container/php/conf.d/php$php-module.conf conf/$container/conf.d/php$php-module.conf
            fi

            # Copy docker files configuration according to php version
            if [ -d $SKYFLOW_DOCKER_DIR/container/$container/php ]; then
                cp $SKYFLOW_DOCKER_DIR/container/$container/php/* ./
            fi
            break
          ;;
          none)
            cp $SKYFLOW_DOCKER_DIR/container/$container/default/* ./
            break
          ;;
          *)
            skyflowHelperPrintError "Invalid selection"
          ;;
        esac
    done

    if [ -f Dockerfile ]; then
        sed -i "s/{{ *server.type *}}/$container/g" Dockerfile
        sed -i "s/{{ *php.version *}}/$php/g" Dockerfile
    fi
    if [ -f docker-compose.yml ]; then
        sed -i "s/{{ *server.type *}}/$container/g" docker-compose.yml
        sed -i "s/{{ *php.version *}}/$php/g" docker-compose.yml
    fi

}

function skyflowDockerOnContainerProgress
{
    if [ "$1" == "application.name" ]; then
        # Lower upper
        echo "$2" | tr '[:upper:]' '[:lower:]'
        exit 0
    fi

    printf "%s" "$2"
}

function skyflowDockerOnContainerFinish
{
    dockerHelperOnContainerFinish
}