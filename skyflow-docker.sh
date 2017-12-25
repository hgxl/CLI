#! /bin/sh

export SKYFLOW_DIR=$HOME/.skyflow
export SKYFLOW_DOCKER_VERSION="1.0.0"

author="Skyflow Team - Franck Diomandé <fkdiomande@gmail.com>"
versionMessage="Skyflow Docker CLI version $SKYFLOW_DOCKER_VERSION"
docFile="$SKYFLOW_DIR/component/docker/doc.ini"

function init()
{
    cd $PWD
    if [ -d docker ] && test -z $1; then
    	./helper.sh "printError" "docker directory already exists. Use -f option to continue."
    	exit 1
	fi
	if [ -d docker ]; then
    	rm -rf docker
	fi

    mkdir docker docker/conf docker/extra docker/compose

    # Select server type
    cd $SKYFLOW_DIR/component/docker/server
    export PS3="Select your server : "
    select server in *
    do
        case $server in
          apache2|nginx)
             break
          ;;
          *)
            ./helper.sh "printError" "Invalid selection"
          ;;
        esac
    done

    cd $PWD
    # Copy docker.ini
    cp $SKYFLOW_DIR/component/docker/server/$server/docker.ini docker/docker.ini

     # Select php version
    export PS3="Select your php version : "
    select php in 5 7 none
    do
        case $php in
          5|7)
            cp -R $SKYFLOW_DIR/component/docker/conf/php$php docker/conf/php$php
            cp -R $SKYFLOW_DIR/component/docker/extra/php$php docker/extra/php$php
            # Set server configuration according to php version
            if [ -d $SKYFLOW_DIR/component/docker/conf/$server/php$php ]; then
    	        cp -R $SKYFLOW_DIR/component/docker/conf/$server/php$php docker/conf/$server
	        fi
            if [ -d $SKYFLOW_DIR/component/docker/server/$server/php ]; then
    	        cp $SKYFLOW_DIR/component/docker/server/$server/php/Dockerfile docker/Dockerfile
                cp $SKYFLOW_DIR/component/docker/server/$server/php/docker-compose.yml docker/docker-compose.yml
	        fi
            break
          ;;
          none)
            cp -R $SKYFLOW_DIR/component/docker/conf/$server/default docker/conf/$server
            cp $SKYFLOW_DIR/component/docker/server/$server/default/Dockerfile docker/Dockerfile
            cp $SKYFLOW_DIR/component/docker/server/$server/default/docker-compose.yml docker/docker-compose.yml
            break
          ;;
          *)
            ./helper.sh "printError" "Invalid selection"
          ;;
        esac
    done

    sed -i "s/ *= */=/g" docker/docker.ini
    sed -i "s/{{ *server.type *}}/$server/g" docker/Dockerfile
    sed -i "s/{{ *server.type *}}/$server/g" docker/docker-compose.yml
    sed -i "s/{{ *php.version *}}/$php/g" docker/Dockerfile
    sed -i "s/{{ *php.version *}}/$php/g" docker/docker-compose.yml

    while IFS== read -u3 key value
    do
        read -p "$key [$value] : " newValue

#        if test -z $newValue; then
#    	    $newValue=$value
#	    fi
        sed -i "s/$key *= *$value/$key = $newValue/g" docker/docker.ini
        sed -i "s/{{ *$key *}}/$newValue/g" docker/Dockerfile
        sed -i "s/{{ *$key *}}/$newValue/g" docker/docker-compose.yml
    done 3< docker/docker.ini


}











case $1 in
    "-h"|"--help")
        ./helper.sh "-h" "Skyflow Docker CLI" "$author" $docFile
    ;;
    "-v"|"--version")
        ./helper.sh "-v" "$versionMessage" "$author"
    ;;
    "init"|"create")
        init "$2"
    ;;
    *)
        ./helper.sh "-h" "Skyflow Docker CLI" "$author" $docFile
    ;;
esac

exit 0
