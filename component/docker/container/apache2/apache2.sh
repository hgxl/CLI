#! /bin/sh

#export SKYFLOW_DIR=$HOME/.skyflow

# =======================================

function skyflowGetFromIni()
{
    $SKYFLOW_DIR/helper.sh "getFromIni" "$1" "$2"
}

# =======================================

function skyflowApache2Init()
{
    local container=$CURRENT_CONTAINER
    local dockerDir=$SKYFLOW_DIR/component/docker

    export PS3="Select your php version : "
    select php in 5 7 none
    do
        case $php in
          5|7)

            if [ -d $dockerDir/conf/php$php ]; then
                cp -r $dockerDir/conf/php$php conf/php$php
                if [ -f conf/php$php/conf.d/.gitignore ]; then
                    rm conf/php$php/conf.d/.gitignore
                fi
            fi

            if [ -d $dockerDir/extra/php$php ]; then
                cp -r $dockerDir/extra/php$php extra/php$php
                if [ -f extra/php$php/modules/.gitignore ]; then
                    rm extra/php$php/modules/.gitignore
                fi
            fi

            # Set container configuration according to php version
            if [ -d $dockerDir/conf/$container/php$php ]; then
                cp -r $dockerDir/conf/$container/php$php conf/$container
            fi
            if [ -d $dockerDir/container/$container/php ]; then
                cp $dockerDir/container/$container/php/* ./
            fi
            break
          ;;
          none)
            cp -r $dockerDir/conf/$container/default conf/$container
            cp $dockerDir/container/$container/default/* ./
            break
          ;;
          *)
            $SKYFLOW_DIR/helper.sh "printError" "Invalid selection"
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

function skyflowApache2BeforeWrite()
{
    if [ "$1" == "application.name" ]; then
        # Lower upper
        echo "$2" | tr '[:upper:]' '[:lower:]'
        exit 0
    fi

    echo "$2"
}

function skyflowApache2Finish()
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
        $SKYFLOW_DIR/helper.sh "printSuccess" "'$directoryIndex' file was created."
    fi

    if [ "$directoryIndex" != "." ] && [ ! -f ../$documentRoot/$directoryIndex ]; then
        touch ../$documentRoot/$directoryIndex
        $SKYFLOW_DIR/helper.sh "printSuccess" "'$documentRoot/$directoryIndex' file was created."
    fi

    # Add server name to hosts file
    sudo chmod 777 docker.ini
    echo -e "127.0.0.1\t$serverName" >> /etc/hosts
    $SKYFLOW_DIR/helper.sh "printSuccess" "'$serverName' added to your hosts file."
    echo -e "\033[0;94mGo to \033[4;94m$serverName:$containerPort\033[0m"
}

case $1 in
    "init")
        skyflowApache2Init
    ;;

    "beforeWrite")
        skyflowApache2BeforeWrite "$2" "$3"
    ;;

    "finish")
        skyflowApache2Finish
    ;;
esac
