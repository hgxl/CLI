#! /bin/sh

export SKYFLOW_DIR=$HOME/.skyflow

dockerDir=$SKYFLOW_DIR/component/docker

container=$1

$SKYFLOW_DIR/helper.sh "findComposeFile"

export PS3="Select your php version : "
select php in 5 7 none
do
    case $php in
      5|7)

        if [ -d $dockerDir/conf/php$php ]; then
            cp -r $dockerDir/conf/php$php conf/php$php
            rm conf/php$php/conf.d/.gitignore
        fi

        if [ -d $dockerDir/extra/php$php ]; then
            cp -r $dockerDir/extra/php$php extra/php$php
            rm extra/php$php/modules/.gitignore
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
    sed -i "s/{{ *container.type *}}/$container/g" Dockerfile
    sed -i "s/{{ *php.version *}}/$php/g" Dockerfile
fi
if [ -f docker-compose.yml ]; then
    sed -i "s/{{ *container.type *}}/$container/g" docker-compose.yml
    sed -i "s/{{ *php.version *}}/$php/g" docker-compose.yml
fi

