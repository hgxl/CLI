#! /bin/bash

if [ "$USER" == "root" ]; then
    echo -e "\033[0;31mSkyflow error: Run without 'root' user.\033[0m"
    exit 1
fi

#source ./helper.sh
source $HOME/.skyflow/helper.sh

#source ./component/docker/helper.sh
source $HOME/.skyflow/component/docker/helper.sh

author="Skyflow Team - Franck Diomandé <fkdiomande@gmail.com>"
versionMessage="Skyflow Docker CLI version $SKYFLOW_DOCKER_VERSION"
docFile="$SKYFLOW_DOCKER_DIR/docker.sdoc"
playbook=1

# Todo: Create new group and add current user and apache and docker
# Todo: Can not access to application by localhost for apache2

function skyflowDockerInit
{
    if [ -d docker ] && [ "$1" != "-f" ]; then
    	skyflowHelperPrintError "docker directory already exists. Use -f option to continue"
    	exit 1
	fi
	[ -d docker ] && sudo rm -rf docker

    mkdir -p docker/conf docker/extra

    # Select container type
    export PS3="Select your container : "
    select container in $(cat $SKYFLOW_DOCKER_DIR/list/container.ls)
    do
        if grep -Fxq "$container" $SKYFLOW_DOCKER_DIR/list/container.ls; then
            break
        fi

        skyflowHelperPrintError "Invalid selection"
    done

    export CURRENT_CONTAINER=$container

    for element in container conf extra; do

        if grep -Fxq "$container" $SKYFLOW_DOCKER_DIR/list/$element.ls; then

            if [ ! -f $SKYFLOW_DOCKER_DIR/make/$element/$container.sh ]; then
                mkdir -p $SKYFLOW_DOCKER_DIR/make/$element
                skyflowHelperPullFromRemote "component/docker/make/$element/$container.sh" "$SKYFLOW_DOCKER_DIR/make/$element/$container.sh"
                sudo chmod +x $SKYFLOW_DOCKER_DIR/make/$element/$container.sh
            fi
            # Create directories and get files for selected container
            [ ! -d $SKYFLOW_DOCKER_DIR/$element/$container ] && $SKYFLOW_DOCKER_DIR/make/$element/$container.sh

        fi

    done

    cd docker

    cp $SKYFLOW_DOCKER_DIR/container/$container/$container.ini docker.ini

    source $SKYFLOW_DOCKER_DIR/container/$container/$container.sh

    skyflowDockerOnContainerInit

    DONE=false
    until $DONE; do
        read -u3 line || DONE=true

        # First char
        firstchar=${line:0:1}

        if [ "$firstchar" == "[" ] || [ "$firstchar" == ";" ]; then
            continue
        fi

        key=`expr match "$line" "\([^ ]*\) *= .*"`
        value=`expr match "$line" "$key *= *\(.*\)"`

        read -p "$key [$value] : " newValue

        if test -z $newValue; then
    	    newValue=$value
	    fi

	    printf "\033[0;92m✓ %s\033[0m\n" "$newValue"

	    newValue=$(skyflowDockerOnContainerProgress "$key" "$newValue")

        if [ -f Dockerfile ]; then
            sed -i "s/{{ *$key *}}/$newValue/g" Dockerfile
        fi
        if [ -f docker-compose.yml ]; then
            sed -i "s/{{ *$key *}}/$newValue/g" docker-compose.yml
        fi

        sed -i "s/ *$key *= *$value/$key = $newValue/g" docker.ini

    done 3< docker.ini

    skyflowDockerOnContainerFinish

    skyflowHelperPrintSuccess "Your docker environment is ready! Run 'skyflow-docker up' command to up your environment"
}

function skyflowDockerUp
{
    findDockerComposeFile
    docker-compose up --build -d
}

function skyflowDockerLs
{
    # Trim : Remove last 's' char
    input=$1

    case $input in

        "image"|"images"|"container"|"containers")
            input=$(skyflowHelperTrim $input "s")
            skyflowHelperRunCommand "docker $input ls -a"
        ;;
        "compose")
            cd $SKYFLOW_DOCKER_DIR/compose
            count=0

            printf "\n\033[0;96mSkyflow docker compose:\033[0m\n"
            start=1; end=30
            for ((i=$start; i<=$end; i++)); do printf "\033[0;96m-\033[0m"; done
            printf "\n"

            DONE=false
            until $DONE; do
                read compose || DONE=true

                count=$((count + 1))
                printf "%s - \033[0;35m%s\033[0m\n" "$count" "$compose"

            done < $SKYFLOW_DOCKER_DIR/list/compose.ls
            printf "\n"

        ;;
        *)
            skyflowHelperRunCommand "docker container ls -a"
        ;;
    esac
}

function skyflowDockerRm
{
    case $1 in

        "container"|"containers")

            [ "$2" == "-a" ] && skyflowHelperRunCommand "docker rm -f -v $(docker ps -a -q)"
            findDockerComposeFile
            [ "$2" != "-a" ] && skyflowHelperRunCommand "docker-compose rm -s -f -v"

        ;;
        "image"|"images")

            skyflowHelperRunCommand "docker rmi -f $(docker images -q)"

        ;;
        *)
            skyflowHelperPrintError "Can't run skyflow-docker rm $1 $2"
            exit 1
        ;;
    esac

}

function skyflowDockerStop
{
    [ "$1" == "-a" ] && skyflowHelperRunCommand "docker stop $(docker ps -aq)"
    findDockerComposeFile
    [ "$1" != "-a" ] && skyflowHelperRunCommand "docker-compose stop"
}

function skyflowDockerPrune
{
    skyflowHelperRunCommand "docker system prune -a"
}

function skyflowDockerUseCompose
{
    local compose=$1

    if ! grep -Fxq "$compose" $SKYFLOW_DOCKER_DIR/list/compose.ls; then
        skyflowHelperPrintError "Compose '$compose' not found. Use 'skyflow-docker ls compose' command"
    	exit 1
    fi

    if [ ! -f $SKYFLOW_DOCKER_DIR/compose/$compose.yml ]; then
        skyflowHelperPullFromRemote "component/docker/compose/$compose.yml" "$SKYFLOW_DOCKER_DIR/compose/$compose.yml"
    fi

    if [ ! -f $SKYFLOW_DOCKER_DIR/compose/$compose.ini ]; then
        skyflowHelperPullFromRemote "component/docker/compose/$compose.ini" "$SKYFLOW_DOCKER_DIR/compose/$compose.ini"
    fi

    skyflowDockerPullConfAndExtraConf "$compose"

    # Enter docker directory
    findDockerComposeFile

    local composeContent=`cat $SKYFLOW_DOCKER_DIR/compose/$compose.yml`
    echo -e "\n$composeContent" >> docker-compose.yml

    if [ -d $SKYFLOW_DOCKER_DIR/conf/$compose ] && [ ! -d conf/$compose ]; then
        cp -r $SKYFLOW_DOCKER_DIR/conf/$compose conf/$compose
    fi

    if [ -d $SKYFLOW_DOCKER_DIR/extra/$compose ] && [ ! -d extra/$compose ]; then
        cp -r $SKYFLOW_DOCKER_DIR/extra/$compose extra/$compose
    fi

    while read -u3 line
    do
        # First char
        local firstchar=${line:0:1}

        if [ "$firstchar" == "[" ] || [ "$firstchar" == ";" ]; then
            continue
        fi

        local key=`expr match "$line" "\([^ ]*\) *= .*"`
        local value=`expr match "$line" "$key *= *\(.*\)"`

        read -p "$key [$value] : " newValue

        if test -z $newValue; then
    	    newValue=$value
	    fi

	    printf "\033[0;92m✓ %s\033[0m\n" "$newValue"

        if [ -f Dockerfile ]; then
            sed -i "s#{{ *$key *}}#$newValue#g" Dockerfile
        fi
        if [ -f docker-compose.yml ]; then
            sed -i "s#{{ *$key *}}#$newValue#g" docker-compose.yml
        fi
        if [ -f conf/$compose/Dockerfile ]; then
            sed -i "s#{{ *$key *}}#$newValue#g" conf/$compose/Dockerfile
        fi

    done 3< $SKYFLOW_DOCKER_DIR/compose/$compose.ini
    
}

function skyflowExecContainer
{
    local container=`expr match "$1" "\([^:]*\):[a-z0-9_-]*"`
    local command=`expr match "$1" "[^:]*:\(.*\)"`

    args=$2

    local type="alpine"
    sudo docker-compose exec $container apt-get >> /dev/null
    [ $? -eq 0 ] && type="debian"

    case $command in
        "stop")
            skyflowHelperRunCommand "docker stop $container"
            exit $?
        ;;
        "exec")
            fullCommand="$args"
        ;;
        "update")
            fullCommand="apk update $args"
            [ "$type" == "debian" ] && fullCommand="apt-get update $args"
        ;;
        "add"|"install")
            fullCommand="apk add --no-cache $args"
            [ "$type" == "debian" ] && fullCommand="apt-get install $args"
        ;;
        "del"|"remove")
            fullCommand="apk del $args"
            [ "$type" == "debian" ] && fullCommand="apt-get remove $args"
        ;;
        "shell"|"enter")
            fullCommand="sh"
            [ "$type" == "debian" ] && fullCommand="bash"
        ;;
        *)
            skyflowHelperPrintError "'$fullCommand' command not found"
            exit 1
        ;;
    esac

    printf "\033[0;94mRunning %s:%s %s ...\033[0m\n" "$container" "$command" "$args"
    sudo docker-compose exec $container $fullCommand
    if [ $? -eq 0 ]; then
        commands=(shell enter)
        if [[ ! ${commands[*]} =~ "$command" ]] && [ $playbook -eq 1 ]; then
            [ ! -f playbook ] && touch playbook
            echo "$container:$command $args" >> playbook
        fi
        skyflowHelperPrintSuccess "docker-compose exec $container $fullCommand"
    else
        skyflowHelperPrintError "Failed to execute '$fullCommand' command in '$container' container"
    fi
}

function skyflowPlaybook
{
    findDockerComposeFile

    if [ ! -f playbook ]; then
        skyflowHelperPrintInfo "No playbook recorded!"
        exit 0
    fi

    # Disabled playbook
    playbook=0

    while read -u3 line
    do
        skyflowExecContainer $line

    done 3< playbook
}

# =======================================

case $1 in
    "-h"|"--help")
        skyflowHelperPrintHelp "Skyflow Docker CLI" "$author" "$docFile"
    ;;
    "-v"|"--version")
        skyflowHelperPrintVersion "$versionMessage" "$author"
    ;;
    "init"|"create")
        skyflowDockerInit "$2"
    ;;
    "up")
        skyflowDockerUp
    ;;
    "ls")
        skyflowDockerLs "$2"
    ;;
    "rm")
        skyflowDockerRm "$2" "$3"
    ;;
    "stop")
        skyflowDockerStop "$2"
    ;;
    "prune")
        skyflowDockerPrune
    ;;
    "use"|"compose")
        skyflowDockerUseCompose "$2"
    ;;
    "playbook")
        skyflowPlaybook
    ;;
    *)
        findDockerComposeFile

        if [[ $1 =~ ^[a-z0-9_-]+:[a-z0-9_-]+$ ]]; then
            skyflowExecContainer "$1" "$2"
            exit 0
        fi
        skyflowHelperRunCommand "docker-compose $1"
    ;;
esac

exit 0
