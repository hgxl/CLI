#! /bin/sh

export SKYFLOW_DIR=$HOME/.skyflow
export SKYFLOW_DOCKER_VERSION="1.0.0"
export SKYFLOW_GITHUB_URL="https://github.com/franckdiomande/Skyflow-cli.git"

function help()
{
    echo
    echo -e "\033[0;96mSkyflow Docker CLI\033[0m\033[0;37m - Franck Diomandé <fkdiomande@gmail.com>\033[0m"

    start=1
    end=100
    for ((i=$start; i<=$end; i++)); do echo -n -e "\033[0;96m-\033[0m"; done

    echo

    while IFS== read command desc
    do
        len=${#command}
        echo -n -e "\033[0;35m$command\033[0m"
        for ((i=1; i<=20-$len; i++)); do echo -n " "; done
        echo -n -e "\033[0;30m$desc\033[0m"
        echo
    done < $SKYFLOW_DIR/docker/doc.ini

    echo
}

function version()
{
    echo -e "\033[0;96mSkyflow Docker CLI version $SKYFLOW_DOCKER_VERSION\033[0m"
    echo -e "\033[0;37mSkyflow Team - Franck Diomandé <fkdiomande@gmail.com>\033[0m"
}

case $1 in
    "-h")
        help
    ;;
    "--help")
        help
    ;;
    "-v")
        version
    ;;
    "--version")
        version
    ;;
    *)
        help
    ;;
esac

exit 0
