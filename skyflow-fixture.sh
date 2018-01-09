#! /bin/sh

if [ "$USER" == "root" ]; then
    echo -e "\033[0;31mSkyflow error: Run without 'root' user.\033[0m"
    exit 1
fi

source ./helper.sh
#source $HOME/.skyflow/helper.sh

#source ./component/docker/helper.sh
#source $HOME/.skyflow/component/docker/helper.sh

#author="Skyflow Team - Franck Diomandé <fkdiomande@gmail.com>"
#versionMessage="Skyflow Docker CLI version $SKYFLOW_DOCKER_VERSION"
#docFile="$SKYFLOW_DIR/component/docker/doc.ini"

#CWD=$PWD

function skyflowFixtureList()
{
    count=0;
    printf "\n\033[0;96mSkyflow Fixture CLI:\033[0m\n"
    start=1
    end=25
    for ((i=$start; i<=$end; i++)); do printf "\033[0;96m-\033[0m"; done
    printf "\n"

    DONE=false
    until $DONE; do
        read fixture || DONE=true

        count=$((count + 1))
        printf "%s - \033[0;35m%s\033[0m\n" "$count" "$fixture"

    done < $SKYFLOW_DIR/component/fixture/fixtures.txt

    printf "\n"
}

# =======================================

case $1 in
    "-h"|"--help")
#        skyflowHelperPrintHelp "Skyflow Docker CLI" "$author" "$docFile"
    ;;
    "-v"|"--version")
#        skyflowHelperPrintVersion "$versionMessage" "$author"
    ;;
    "list")
        skyflowFixtureList
    ;;
    *)

    ;;
esac

exit 0
