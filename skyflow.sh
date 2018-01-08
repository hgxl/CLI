#! /bin/sh

if [ "$USER" == "root" ]; then
    echo -e "\033[0;31mSkyflow error: Run without 'root' user.\033[0m"
    exit 1
fi

#source ./helper.sh
source $HOME/.skyflow/helper.sh

author="Skyflow Team - Franck Diomandé <fkdiomande@gmail.com>"
versionMessage="Skyflow CLI version $SKYFLOW_VERSION"
docFile="$SKYFLOW_DIR/doc.ini"

function skyflowInit()
{
    case $1 in
        "-f")
            if [ -d $SKYFLOW_DIR ]; then
                rm -rf $SKYFLOW_DIR
            fi
        ;;
    esac

    # Create skyflow directory for current user
    if [ ! -d $SKYFLOW_DIR ]; then
        mkdir $SKYFLOW_DIR
    fi

    if [ ! -d $SKYFLOW_DIR/component ]; then
        mkdir $SKYFLOW_DIR/component
    fi

    if [ ! -f $SKYFLOW_DIR/doc.ini ]; then
        curl -s $SKYFLOW_GITHUB_CONTENT/doc.ini -o $SKYFLOW_DIR/doc.ini
    fi

    if [ ! -f $SKYFLOW_DIR/helper.sh ]; then
        curl -s $SKYFLOW_GITHUB_CONTENT/helper.sh -o $SKYFLOW_DIR/helper.sh
    fi

    if [ ! -f $SKYFLOW_DIR/component.txt ]; then
        curl -s $SKYFLOW_GITHUB_CONTENT/component.txt -o $SKYFLOW_DIR/component.txt
    fi

}

skyflowInit

function skyflowInstall()
{
#    componentCacheDir=$SKYFLOW_CACHE_DIR/component/$1

    # Check if component exists
#    if [ ! -d $componentCacheDir ] || test -z $1; then
#    	skyflowHelperPrintError "$1 component not found"
#    	exit 1
#	fi

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
    sudo cp $SKYFLOW_CACHE_DIR/bin/skyflow-$1.sh /usr/local/bin/skyflow-$1
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
