#! /bin/sh

if [ "$USER" == "root" ]; then
    echo -e "\033[0;31mSkyflow error: Run without 'root' user.\033[0m"
    exit 1
fi

export SKYFLOW_DIR=$HOME/.skyflow
export SKYFLOW_DOCKER_VERSION="1.0.0"

author="Skyflow Team - Franck Diomandé <fkdiomande@gmail.com>"
versionMessage="Skyflow Docker CLI version $SKYFLOW_DOCKER_VERSION"
docFile="$SKYFLOW_DIR/component/docker/doc.ini"
playbook=1

CWD=$PWD

# Todo: Create new group and add current user and apache and docker
# Todo: Can not access to application by localhost

# =======================================

function skyflowRunCommand()
{
    $SKYFLOW_DIR/helper.sh "runCommand" "$1"
}

function findDockerComposeFile()
{
        if [ -d docker ] && [ ! -f docker-compose.yml ]; then
            cd docker
        fi

        if [ ! -f docker-compose.yml ]; then
            $SKYFLOW_DIR/helper.sh "printError" "docker-compose.yml file not found"
            exit 1
        fi
}

function skyflowTrim()
{
    $SKYFLOW_DIR/helper.sh "trim" "$1" "$2"
}

function skyflowGetFromIni()
{
    $SKYFLOW_DIR/helper.sh "getFromIni" "$1" "$2"
}

# =======================================

function skyflowDockerInit()
{
    if [ -d docker ] && test -z $1; then
    	$SKYFLOW_DIR/helper.sh "printError" "docker directory already exists. Use -f option to continue"
    	exit 1
	fi
	if [ -d docker ]; then
    	sudo rm -rf docker
	fi

    mkdir docker docker/conf docker/extra

    containerDir=$SKYFLOW_DIR/component/docker/container

    # Select container type
    cd $containerDir
    export PS3="Select your container : "
    select container in *
    do
        if [ -d $container ]; then
            break
        fi
        $SKYFLOW_DIR/helper.sh "printError" "Invalid selection"
    done

    export CURRENT_CONTAINER=$container

    cd $CWD/docker

    cp $containerDir/$container/$container.ini docker.ini

    if [ -f $containerDir/$container/$container.sh ]; then
        if [ ! -x $containerDir/$container/$container.sh ]; then
            sudo chmod +x $containerDir/$container/$container.sh
        fi
        $containerDir/$container/$container.sh "init"
    fi

    while read -u3 line
    do
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

	    echo -e "\033[0;92m✓ $newValue\033[0m"

	    if [ -f $containerDir/$container/$container.sh ]; then
            newValue=$($containerDir/$container/$container.sh "beforeWrite" "$key" "$newValue")
        fi

        if [ -f Dockerfile ]; then
            sed -i "s/{{ *$key *}}/$newValue/g" Dockerfile
        fi
        if [ -f docker-compose.yml ]; then
            sed -i "s/{{ *$key *}}/$newValue/g" docker-compose.yml
        fi

        sed -i "s/ *$key *= *$value/$key = $newValue/g" docker.ini

    done 3< docker.ini

    if [ -f $containerDir/$container/$container.sh ]; then
        $containerDir/$container/$container.sh "finish"
    fi

    $SKYFLOW_DIR/helper.sh "printSuccess" "Your docker environment is ready! Run 'skyflow-docker up' command to up your environment"
}

function skyflowDockerUp()
{
    findDockerComposeFile
    skyflowRunCommand "docker-compose up --build -d"
}

function skyflowDockerLs()
{
    # Trim : Remove last 's' char
    input=$1
    input=$(skyflowTrim $input "s")

    case $input in
        "image"|"container")
            skyflowRunCommand "docker $input ls -a"
        ;;
        "compose")
            cd $SKYFLOW_DIR/component/docker/compose
            count=0

            echo
            echo -e "\033[0;96mSkyflow docker compose:\033[0m"
            start=1
            end=30
            for ((i=$start; i<=$end; i++)); do echo -n -e "\033[0;96m-\033[0m"; done
            echo

            for compose in *.yml
            do
                count=$((count + 1))
                echo -e "$count - \033[0;35m$compose\033[0m"
            done
            echo
        ;;
        *)
            skyflowRunCommand "docker container ls -a"
        ;;
    esac
}

function skyflowDockerRm()
{
    # Trim : Remove last 's' char
    input=$1
    input=$(skyflowTrim $input "s")

    if test -z $input; then
        input="container"
    fi

    skyflowRunCommand "docker $input rm $(docker $input ls -a -q) -f"
}

function skyflowDockerUseCompose()
{
    local compose=$1
    local dockerDir=$SKYFLOW_DIR/component/docker
    if [ ! -f $dockerDir/compose/$compose.yml ]; then
        $SKYFLOW_DIR/helper.sh "printError" "Compose '$compose' not found. Use 'skyflow-docker ls compose' command"
        exit 1
    fi

    # Enter docker directory
    findDockerComposeFile

    local composeContent=`cat $dockerDir/compose/$compose.yml`
    echo -e "\n$composeContent" >> docker-compose.yml

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

	    echo -e "\033[0;92m✓ $newValue\033[0m"

        if [ -f Dockerfile ]; then
            sed -i "s#{{ *$key *}}#$newValue#g" Dockerfile
        fi
        if [ -f docker-compose.yml ]; then
            sed -i "s#{{ *$key *}}#$newValue#g" docker-compose.yml
        fi

    done 3< $dockerDir/compose/$compose.ini

    if [ -d $dockerDir/conf/$compose ] && [ ! -d conf/$compose ]; then
        cp -r $dockerDir/conf/$compose conf/$compose
    fi

    if [ -d $dockerDir/extra/$compose ] && [ ! -d extra/$compose ]; then
        cp -r $dockerDir/extra/$compose extra/$compose
    fi
}

function skyflowExecContainer()
{
    local container=`expr match "$1" "\([^:]*\):[a-z0-9_-]*"`
    local command=`expr match "$1" "[^:]*:\(.*\)"`

    args=$2

    local type="alpine"
    sudo docker-compose exec $container apt-get >> /dev/null
    if [ $? -eq 0 ]; then
        type="debian"
    fi

    case $command in
        "exec")
            fullCommand="$args"
        ;;
        "update")
            fullCommand="apk update $args"
            if [ "$type" == "debian" ]; then
                fullCommand="apt-get update $args"
            fi
        ;;
        "add"|"install")
            fullCommand="apk add --no-cache $args"
            if [ "$type" == "debian" ]; then
                fullCommand="apt-get install $args"
            fi
        ;;
        "del"|"remove")
            fullCommand="apk del $args"
            if [ "$type" == "debian" ]; then
                fullCommand="apt-get remove $args"
            fi
        ;;
        "shell"|"enter")
            fullCommand="sh"
            if [ "$type" == "debian" ]; then
                fullCommand="bash"
            fi
        ;;
        *)
            $SKYFLOW_DIR/helper.sh "printError" "'$fullCommand' command not found"
            exit 1
        ;;
    esac

    echo -e "\033[0;94mRunning $container:$command $args ...\033[0m"
    sudo docker-compose exec $container $fullCommand
    if [ $? -eq 0 ]; then
        commands=(shell enter)
        if [[ ! ${commands[*]} =~ "$command" ]] && [ $playbook -eq 1 ]; then
            if [ ! -f playbook ]; then
                touch playbook
            fi
            echo "$container:$command $args" >> playbook
        fi
        $SKYFLOW_DIR/helper.sh "printSuccess" "docker-compose exec $container $fullCommand"
    else
        $SKYFLOW_DIR/helper.sh "printError" "Failed to execute '$fullCommand' command in '$container' container"
    fi
}


function skyflowPlaybook()
{
    findDockerComposeFile

    if [ ! -f playbook ]; then
        $SKYFLOW_DIR/helper.sh "printInfo" "No playbook recorded!"
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
        $SKYFLOW_DIR/helper.sh "-h" "Skyflow Docker CLI" "$author" "$docFile"
    ;;
    "-v"|"--version")
        $SKYFLOW_DIR/helper.sh "-v" "$versionMessage" "$author"
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
        skyflowDockerRm "$2"
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
        skyflowRunCommand "docker-compose $1"
    ;;
esac

exit 0
