#! /bin/sh

export SKYFLOW_DIR=$HOME/.skyflow

container="apache2"; cd $1/docker
dockerDir=$SKYFLOW_DIR/component/docker

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
