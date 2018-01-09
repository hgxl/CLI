#! /bin/sh

if [ "$USER" == "root" ]; then
    printf "\033[0;31mSkyflow error: Run without 'root' user.\033[0m"
    exit 1
fi

export SKYFLOW_DIR=$HOME/.skyflow
export SKYFLOW_GITHUB_CONTENT="https://raw.githubusercontent.com/franckdiomande/Skyflow-cli/master"

function skyflowInit()
{
    case $1 in
        "-f")
            if [ -d $SKYFLOW_DIR ]; then
                rm -rf $SKYFLOW_DIR
            fi
        ;;
    esac

    if [ ! -d $SKYFLOW_DIR/component ]; then
        mkdir -p $SKYFLOW_DIR/component
    fi

    if [ ! -f $SKYFLOW_DIR/doc.ini ]; then
        curl -s "$SKYFLOW_GITHUB_CONTENT/doc.ini" -o $SKYFLOW_DIR/doc.ini
        [ ! $? -eq 0 ] && skyflowHelperPrintCurlFailedError "doc.ini"
    fi

    if [ ! -f $SKYFLOW_DIR/helper.sh ]; then
        curl -s "$SKYFLOW_GITHUB_CONTENT/helper.sh" -o $SKYFLOW_DIR/helper.sh
        [ ! $? -eq 0 ] && skyflowHelperPrintCurlFailedError "helper.sh"
    fi

    if [ ! -f $SKYFLOW_DIR/component.ls ]; then
        curl -s "$SKYFLOW_GITHUB_CONTENT/component.ls" -o $SKYFLOW_DIR/component.ls
        [ ! $? -eq 0 ] && skyflowHelperPrintCurlFailedError "component.ls"
    fi

}

skyflowInit

#source ./helper.sh
source $SKYFLOW_DIR/helper.sh

author="Skyflow Team - Franck Diomandé <fkdiomande@gmail.com>"
versionMessage="Skyflow CLI version $SKYFLOW_VERSION"
docFile="$SKYFLOW_DIR/doc.ini"

function skyflowInstall()
{
	if ! grep -Fxq "$1" $SKYFLOW_DIR/component.ls
	then
        skyflowHelperPrintError "$1 component not found"
    	exit 1
    fi

	# Exit if component already exists
    if [ -d $SKYFLOW_DIR/component/$1 ] && [ -f /usr/local/bin/skyflow-$1 ]; then
    	skyflowHelperPrintInfo "$1 component is already installed"
    	exit 0
	fi

    # Run install script
    mkdir -p $SKYFLOW_DIR/component/$1
    curl -s "$SKYFLOW_GITHUB_CONTENT/component/$1/doc.ini" -o $SKYFLOW_DIR/component/$1/doc.ini
    curl -s "$SKYFLOW_GITHUB_CONTENT/component/$1/install.sh" -o $SKYFLOW_DIR/component/$1/install.sh
    sudo chmod +x $SKYFLOW_DIR/component/$1/install.sh
    $SKYFLOW_DIR/component/$1/install.sh
    rm $SKYFLOW_DIR/component/$1/install.sh

    # Install binary
    sudo curl -s "$SKYFLOW_GITHUB_CONTENT/bin/skyflow-$1.sh" -o /usr/local/bin/skyflow-$1
    sudo chmod +x /usr/local/bin/skyflow-$1

    skyflowHelperPrintSuccess "$1 component was successfully installed! Now you can use \033[4;94mskyflow-$1\033[0;92m CLI"
    exit 0
}

function skyflowRemove()
{
    # Check if component exists
    if ! grep -Fxq "$1" $SKYFLOW_DIR/component.ls; then
        skyflowHelperPrintError "$1 component not found"
    	exit 1
    fi

    if [ -d $SKYFLOW_DIR/component/$1 ]; then
    	rm -rf $SKYFLOW_DIR/component/$1
	fi

	if [ -f /usr/local/bin/skyflow-$1 ]; then
    	sudo rm /usr/local/bin/skyflow-$1
	fi

    skyflowHelperPrintSuccess "$1 component was successfully removed!"
    exit 0
}

function skyflowList()
{
    count=0;
    printf "\n\033[0;96mSkyflow CLI components:\033[0m\n"
    start=1
    end=25
    for ((i=$start; i<=$end; i++)); do printf "\033[0;96m-\033[0m"; done
    printf "\n"

    DONE=false
    until $DONE; do
        read component || DONE=true

        count=$((count + 1))
        printf "%s - \033[0;35m%s\033[0m\n" "$count" "$component"

    done < $SKYFLOW_DIR/component.ls

    printf "\n"
}

case $1 in
    "install")
        skyflowInstall "$2"
    ;;
    "remove")
        skyflowRemove "$2"
    ;;
    "list"|"components")
        skyflowList
    ;;
    "init"|"update")
        skyflowInit "-f"
    ;;
    "-h"|"--help")
        skyflowHelperPrintHelp "Skyflow CLI" "$author" "$docFile"
    ;;
    "-v"|"--version")
        skyflowHelperPrintVersion "$versionMessage" "$author"
    ;;
    *)
        skyflowHelperPrintHelp "Skyflow CLI" "$author" "$docFile"
    ;;
esac

exit 0
