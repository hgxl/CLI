#! /bin/sh

export SKYFLOW_DIR=$HOME/.skyflow
export SKYFLOW_DOCKER_VERSION="1.0.0"

author="Skyflow Team - Franck Diomandé <fkdiomande@gmail.com>"
versionMessage="Skyflow Docker CLI version $SKYFLOW_DOCKER_VERSION"
docFile="$SKYFLOW_DIR/component/docker/doc.ini"

CWD=$PWD

# =======================================

function skyflowRunCommand()
{
    $SKYFLOW_DIR/helper.sh "runCommand" "$1"
}

function findDockerComposeFile()
{
    $SKYFLOW_DIR/helper.sh "findComposeFile"
}

function skyflowTrim()
{
    $SKYFLOW_DIR/helper.sh "trim" "$1" "$2"
}

# =======================================

function skyflowDockerInit()
{
    if [ -d docker ] && test -z $1; then
    	$SKYFLOW_DIR/helper.sh "printError" "docker directory already exists. Use -f option to continue."
    	exit 1
	fi
	if [ -d docker ]; then
    	rm -rf docker
	fi

    mkdir docker docker/conf docker/extra

    containerDir=$SKYFLOW_DIR/component/docker/container

    # Select container type
    cd $containerDir
    export PS3="Select your container : "
    select container in *
    do
        case $container in
          apache2|nginx)
             break
          ;;
          *)
            $SKYFLOW_DIR/helper.sh "printError" "Invalid selection"
          ;;
        esac
    done

    cd $CWD/docker

    if [ -f $containerDir/$container/$container.sh ]; then
        sudo chmod +x $containerDir/$container/$container.sh
        $containerDir/$container/$container.sh "init"
    fi

    while IFS== read -u3 key value
    do

        key=$(skyflowTrim $key " ")
        value=$(skyflowTrim $value " ")

        # First char
        firstchar=${key:0:1}

        if [ "$firstchar" == "[" ] || [ "$firstchar" == ";" ]; then
            continue
        fi

        read -p "$key [$value] : " newValue

        if test -z $newValue; then
    	    newValue=$value
	    fi

	    if [ -f $containerDir/$container/$container.sh ]; then
            newValue=$($containerDir/$container/$container.sh "beforeWrite" "$key" "$newValue")
        fi

        # Todo: Create new group and add current user and apache
        if [ -f Dockerfile ]; then
            sed -i "s/{{ *$key *}}/$newValue/g" Dockerfile
        fi
        if [ -f docker-compose.yml ]; then
            sed -i "s/{{ *$key *}}/$newValue/g" docker-compose.yml
        fi

    done 3< $containerDir/$container/$container.ini

    if [ -f $containerDir/$container/$container.sh ]; then
        $containerDir/$container/$container.sh "finish"
    fi

    $SKYFLOW_DIR/helper.sh "printSuccess" "Your docker environment is ready! Run 'skyflow-docker up' command to up your environment."
    exit 0
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
            count=0; echo
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
    compose=$1
    dockerDir=$SKYFLOW_DIR/component/docker
    if [ ! -f $dockerDir/compose/$compose.yml ]; then
        $SKYFLOW_DIR/helper.sh "printError" "Compose '$compose' not found. Use 'skyflow-docker ls compose' command."
        exit 1
    fi

    # Enter docker directory
    findDockerComposeFile

    composeContent=`cat $dockerDir/compose/$compose.yml`
    echo -e "\n\n$composeContent" >> docker-compose.yml

    while IFS== read -u3 key value
    do
        key=$(skyflowTrim $key " ")
        value=$(skyflowTrim $value " ")

        # First char
        firstchar=${key:0:1}

        if [ "$firstchar" == "[" ] || [ "$firstchar" == ";" ]; then
            continue
        fi

        read -p "$key [$value] : " newValue

        if test -z $newValue; then
    	    newValue=$value
	    fi

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
    "use")
        skyflowDockerUseCompose "$2"
    ;;
    *)
        findDockerComposeFile
        skyflowRunCommand "docker-compose $1"
    ;;
esac

exit 0
