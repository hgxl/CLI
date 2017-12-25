#! /bin/sh

export SKYFLOW_DIR=$HOME/.skyflow
export SKYFLOW_DOCKER_VERSION="1.0.0"

author="Skyflow Team - Franck Diomandé <fkdiomande@gmail.com>"
versionMessage="Skyflow Docker CLI version $SKYFLOW_DOCKER_VERSION"
docFile="$SKYFLOW_DIR/component/docker/doc.ini"

function init()
{
    CWD=$PWD
    cd $CWD
    if [ -d docker ] && test -z $1; then
    	$SKYFLOW_DIR/helper.sh "printError" "docker directory already exists. Use -f option to continue."
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
            $SKYFLOW_DIR/helper.sh "printError" "Invalid selection"
          ;;
        esac
    done

    cd $CWD
    # Copy docker.ini
    cp $SKYFLOW_DIR/component/docker/server/$server/docker.ini docker/docker.ini

     # Select php version
    export PS3="Select your php version : "
    select php in 5 7 none
    do
        case $php in
          5|7)

            if [ -d $SKYFLOW_DIR/component/docker/conf/php$php ]; then
    	        cp -R $SKYFLOW_DIR/component/docker/conf/php$php docker/conf/php$php
    	        rm docker/conf/php$php/conf.d/.gitignore
	        fi

            if [ -d $SKYFLOW_DIR/component/docker/extra/php$php ]; then
    	        cp -R $SKYFLOW_DIR/component/docker/extra/php$php docker/extra/php$php
                rm docker/extra/php$php/modules/.gitignore
	        fi

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
            $SKYFLOW_DIR/helper.sh "printError" "Invalid selection"
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

        # Todo: Create new group and add current user and apache
        sed -i "s/$key *= *$value/$key = $newValue/g" docker/docker.ini
        sed -i "s/{{ *$key *}}/$newValue/g" docker/Dockerfile
        sed -i "s/{{ *$key *}}/$newValue/g" docker/docker-compose.yml
    done 3< docker/docker.ini


}

function findDockerComposeFile()
{
    cd $PWD
    if [ -d docker ] && [ ! -f docker-compose.yml ]; then
        cd docker
    fi

    if [ ! -f docker-compose.yml ]; then
        $SKYFLOW_DIR/helper.sh "printError" "docker-compose.yml file not found."
        exit 1
    fi
}

function up()
{
    findDockerComposeFile

    ./helper.sh "runCommand" "docker-compose up --build -d"
}

function ps()
{
    findDockerComposeFile

    $SKYFLOW_DIR/helper.sh "runCommand" "docker-compose up --build -d"
}







case $1 in
    "-h"|"--help")
        $SKYFLOW_DIR/helper.sh "-h" "Skyflow Docker CLI" "$author" $docFile
    ;;
    "-v"|"--version")
        $SKYFLOW_DIR/helper.sh "-v" "$versionMessage" "$author"
    ;;
    "init"|"create")
        init "$2"
    ;;
    "up")
        up
    ;;
    *)
        $SKYFLOW_DIR/helper.sh "-h" "Skyflow Docker CLI" "$author" $docFile
    ;;
esac

exit 0
