#! /bin/sh

function skyflowGetFromIni()
{
    $SKYFLOW_DIR/helper.sh "getFromIni" "$1" "$2"
}

# =======================================

function skyflowNginxInit()
{
    local container=$CURRENT_CONTAINER
    local dockerDir=$SKYFLOW_DIR/component/docker

    # Copy configuration files
    if [ -d $dockerDir/conf/$container ]; then
        cp -r $dockerDir/conf/$container conf/$container
    fi

    # Copy docker-compose.yml file
    if [ -f $dockerDir/container/$container/docker-compose.yml ]; then
        cp $dockerDir/container/$container/docker-compose.yml docker-compose.yml
    fi

}

function skyflowNginxBeforeWrite()
{
    local container=$CURRENT_CONTAINER
    local dockerDir=$SKYFLOW_DIR/component/docker

    local value=$2

    if [ "$1" == "application.name" ]; then
        # Lower upper
        value="$2" | tr '[:upper:]' '[:lower:]'
    fi

    if [ -f $dockerDir/conf/$container/conf.d/default.conf ]; then
        sed -i "s/{{ *$1 *}}/$value/g" $dockerDir/conf/$container/conf.d/default.conf
    fi

    echo "$value"
}

function skyflowNginxFinish()
{

}

case $1 in
    "init")
        skyflowNginxInit
    ;;
    "beforeWrite")
        skyflowNginxBeforeWrite "$2" "$3"
    ;;
    "finish")
        skyflowNginxFinish
    ;;
esac

exit 0