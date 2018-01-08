#! /bin/sh

if [ "$USER" == "root" ]; then
    printf "\033[0;31mSkyflow error: Run without 'root' user.\033[0m"
    exit 1
fi

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
        curl -s $SKYFLOW_GITHUB_CONTENT/doc.ini -o $HOME/.skyflow/doc.ini
    fi

    if [ ! -f $HOME/.skyflow/helper.sh ]; then
        curl -s $SKYFLOW_GITHUB_CONTENT/helper.sh -o $HOME/.skyflow/helper.sh
    fi

    if [ ! -f $HOME/.skyflow/component.txt ]; then
        curl -s $SKYFLOW_GITHUB_CONTENT/component.txt -o $HOME/.skyflow/component.txt
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
#	cp -R $componentCacheDir $SKYFLOW_DIR/component/$1

    # Install binary
    curl -s $SKYFLOW_GITHUB_CONTENT/bin/skyflow-$1.sh -o /usr/local/bin/skyflow-$1
    sudo chmod +x /usr/local/bin/skyflow-$1

    skyflowHelperPrintSuccess "$1 component was successfully installed! Now you can use \033[4;94mskyflow-$1\033[0;92m CLI"
    exit 0
}

function skyflowRemove()
{
    componentCacheDir=$SKYFLOW_CACHE_DIR/component/$1

    # Check if component exists
    if [ ! -d $componentCacheDir ] || test -z $1; then
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
    cd $SKYFLOW_CACHE_DIR/component
    count=0;

    echo
    echo -e "\033[0;96mSkyflow CLI components:\033[0m"
    start=1
    end=25
    for ((i=$start; i<=$end; i++)); do echo -n -e "\033[0;96m-\033[0m"; done
    echo

    for compose in *
    do
        count=$((count + 1))
        echo -e "$count - \033[0;35m$compose\033[0m"
    done
    echo
}

case $1 in
    "install")
        skyflowInstall "$2"
    ;;
    "remove")
        skyflowRemove "$2"
    ;;
    "list")
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
