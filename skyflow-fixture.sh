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

#skyflowHelperPrintSuccess "Salut"

skyflowHelperPrintVersion "Franck" "Toto"

#lc=$(skyflowHelperCountFileLines toto.txt)
lc=$(skyflowHelperGetRandomLineFromFile toto.txt)

echo $lc

# =======================================

case $1 in
    "-h"|"--help")
#        skyflowHelperPrintHelp "Skyflow Docker CLI" "$author" "$docFile"
    ;;
    "-v"|"--version")
#        skyflowHelperPrintVersion "$versionMessage" "$author"
    ;;
    *)

    ;;
esac

exit 0
