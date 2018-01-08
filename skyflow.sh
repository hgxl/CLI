#! /bin/sh

if [ "$USER" == "root" ]; then
    printf "\033[0;31mSkyflow error: Run without 'root' user.\033[0m"
    exit 1
fi

export SKYFLOW_GITHUB_CONTENT="https://raw.githubusercontent.com/franckdiomande/Skyflow-cli/master"

function skyflowInit()
{
    case $1 in
        "-f")
            if [ -d $HOME/.skyflow ]; then
                rm -rf $HOME/.skyflow
            fi
        ;;
    esac

    # Create skyflow directory for current user
    if [ ! -d $HOME/.skyflow ]; then
        mkdir $HOME/.skyflow
    fi

    if [ ! -d $HOME/.skyflow/component ]; then
        mkdir $HOME/.skyflow/component
    fi

    if [ ! -f $HOME/.skyflow/doc.ini ]; then
        curl -s "$SKYFLOW_GITHUB_CONTENT/doc.ini" -o $HOME/.skyflow/doc.ini
    fi

    if [ ! -f $HOME/.skyflow/helper.sh ]; then
        curl -s "$SKYFLOW_GITHUB_CONTENT/helper.sh" -o $HOME/.skyflow/helper.sh
    fi

    if [ ! -f $HOME/.skyflow/component.txt ]; then
        curl -s "$SKYFLOW_GITHUB_CONTENT/component.txt" -o $HOME/.skyflow/component.txt
    fi

}

skyflowInit

#source ./helper.sh
source $HOME/.skyflow/helper.sh

author="Skyflow Team - Franck Diomandé <fkdiomande@gmail.com>"
versionMessage="Skyflow CLI version $SKYFLOW_VERSION"
docFile="$SKYFLOW_DIR/doc.ini"

function skyflowInstall()
{
	if [ ! grep -Fxq "$1" $SKYFLOW_DIR/component.txt ]; then
        skyflowHelperPrintError "$1 component not found"
    	exit 1
    fi

	# Exit if component already exists
    if [ -d $SKYFLOW_DIR/component/$1 ] && [ -f /usr/local/bin/skyflow-$1 ]; then
    	skyflowHelperPrintInfo "$1 component is already installed"
    	exit 0
	fi

    # Run install script
    mkdir $SKYFLOW_DIR/component/$1
    curl -s $SKYFLOW_GITHUB_CONTENT/component/$1/install.sh -o $SKYFLOW_DIR/component/$1/install.sh
    sudo chmod +x $SKYFLOW_DIR/component/$1/install.sh
    rm $SKYFLOW_DIR/component/$1/install.sh

    # Install binary
    curl -s $SKYFLOW_GITHUB_CONTENT/bin/skyflow-$1.sh -o /usr/local/bin/skyflow-$1
    sudo chmod +x /usr/local/bin/skyflow-$1

    skyflowHelperPrintSuccess "$1 component was successfully installed! Now you can use \033[4;94mskyflow-$1\033[0;92m CLI"
    exit 0
}

function skyflowRemove()
{
    # Check if component exists
    if [ ! grep -Fxq "$1" $SKYFLOW_DIR/component.txt ]; then
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
        read compose || DONE=true

        count=$((count + 1))
        printf "%s - \033[0;35m%s\033[0m\n" "$count" "$compose"

    done < $SKYFLOW_DIR/component.txt

    printf "\n"
}

case $1 in
    "install")
        skyflowInstall "$2"
    ;;
    "remove")
        skyflowRemove "$2"
    ;;
    "list|components")
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
