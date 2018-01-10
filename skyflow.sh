#! /bin/sh

if [ "$USER" == "root" ]; then
    printf "\033[0;31mSkyflow error: Run without 'root' user.\033[0m"
    exit 1
fi

export SKYFLOW_DIR=$HOME/.skyflow
export SKYFLOW_GITHUB_CONTENT="https://raw.githubusercontent.com/franckdiomande/Skyflow-cli/master"

# ===========>>>>>>>>>>>>>>> Local helper

# Print skyflow curl failed formatted error message
# Arguments:
# - $1 : Message
function skyflowHelperPrintCurlFailedError()
{
    echo -e "\033[0;31mSkyflow error: Can not find the file '$1'.\033[0m"
    echo -e "\033[0;31mPlease check your internet connection and that the file exists.\033[0m"
    exit 1
}

# Pull resources from remote
# Arguments:
# - $1 : Resource path
# - $2 : Output directory
function skyflowLocalHelperPullFromRemote()
{
    printf "\033[0;94mPulling\033[0m \033[0;92m%s\033[0m \033[0;94mfrom remote ... \033[0m" "$1"
    curl -s "$SKYFLOW_GITHUB_CONTENT/$1" -o $2
    [ ! $? -eq 0 ] && skyflowHelperPrintCurlFailedError "$1"
    printf "\033[0;92mOk\033[0m\n"
}

# End local helper <<<<<<<<<<<===============

function skyflowInit()
{
    case $1 in
        "-f")
            if [ -d $SKYFLOW_DIR ]; then
                [ -d $SKYFLOW_DIR/component ] && rm -rf $SKYFLOW_DIR/component
                [ -f $SKYFLOW_DIR/helper.sh ] && rm $SKYFLOW_DIR/helper.sh
                [ -f $SKYFLOW_DIR/skyflow.sdoc ] && rm $SKYFLOW_DIR/skyflow.sdoc
                [ -f $SKYFLOW_DIR/component.ls ] && rm $SKYFLOW_DIR/component.ls
            fi
        ;;
    esac

    [ ! -d $SKYFLOW_DIR/component ] && mkdir -p $SKYFLOW_DIR/component
    [ ! -f $SKYFLOW_DIR/skyflow.sdoc ] && skyflowLocalHelperPullFromRemote "skyflow.sdoc" "$SKYFLOW_DIR/skyflow.sdoc"
    [ ! -f $SKYFLOW_DIR/helper.sh ] && skyflowLocalHelperPullFromRemote "helper.sh" "$SKYFLOW_DIR/helper.sh"
    [ ! -f $SKYFLOW_DIR/component.ls ] && skyflowLocalHelperPullFromRemote "component.ls" "$SKYFLOW_DIR/component.ls"

}

skyflowInit

#source ./helper.sh
source $SKYFLOW_DIR/helper.sh

author="Skyflow Team - Franck Diomandé <fkdiomande@gmail.com>"
versionMessage="Skyflow CLI version $SKYFLOW_VERSION"
docFile="$SKYFLOW_DIR/skyflow.sdoc"

function skyflowInstall()
{
	if ! grep -Fxq "$1" $SKYFLOW_DIR/component.ls; then
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
    skyflowHelperPullFromRemote "component/$1/$1.doc" "$SKYFLOW_DIR/component/$1/$1.doc"
    skyflowHelperPullFromRemote "component/$1/install.sh" "$SKYFLOW_DIR/component/$1/install.sh"
    sudo chmod +x $SKYFLOW_DIR/component/$1/install.sh
    $SKYFLOW_DIR/component/$1/install.sh
    rm $SKYFLOW_DIR/component/$1/install.sh

    # Install binary
    skyflowHelperPullFromRemote "bin/skyflow-$1.sh" skyflow-$1
    sudo mv skyflow-$1 /usr/local/bin/skyflow-$1
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
