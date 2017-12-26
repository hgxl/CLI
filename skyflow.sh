#! /bin/sh

export SKYFLOW_DIR=$HOME/.skyflow
export SKYFLOW_CACHE_DIR=$SKYFLOW_DIR/cache
export SKYFLOW_VERSION="1.0.0"
export SKYFLOW_GITHUB_URL="https://github.com/franckdiomande/Skyflow-cli.git"

author="Skyflow Team - Franck Diomandé <fkdiomande@gmail.com>"
versionMessage="Skyflow CLI version $SKYFLOW_VERSION"
docFile="$SKYFLOW_DIR/doc.ini"

function skyflowInit()
{
    # Create skyflow directory for current user
    if [ ! -d $SKYFLOW_DIR ]; then
        mkdir $SKYFLOW_DIR
    fi

    if [ ! -d $SKYFLOW_DIR/component ]; then
        mkdir $SKYFLOW_DIR/component
    fi

    case $1 in
        "-f")
            if [ -d $SKYFLOW_CACHE_DIR ]; then
                rm -rf $SKYFLOW_CACHE_DIR
            fi
        ;;
    esac

    if [ ! -d $SKYFLOW_CACHE_DIR ]; then
    	git clone $SKYFLOW_GITHUB_URL $SKYFLOW_CACHE_DIR
    	rm -rf $SKYFLOW_CACHE_DIR/.git
	fi

	cp $SKYFLOW_CACHE_DIR/doc.ini $SKYFLOW_DIR/doc.ini
	cp $SKYFLOW_CACHE_DIR/helper.sh $SKYFLOW_DIR/helper.sh
	sudo chmod +x $SKYFLOW_DIR/helper.sh
}

function skyflowInstall()
{
    componentCacheDir=$SKYFLOW_CACHE_DIR/component/$1

    # Check if component exists
    if [ ! -d $componentCacheDir ] || test -z $1; then
    	$SKYFLOW_DIR/helper.sh "printError" "$1 component not found"
    	exit 1
	fi

	# Exit if component already exists
    if [ -d $SKYFLOW_DIR/component/$1 ] && [ -f /usr/bin/skyflow-$1 ]; then
    	$SKYFLOW_DIR/helper.sh "printInfo" "$1 component is already installed"
    	exit 0
	fi

    # Install component
	cp -R $componentCacheDir $SKYFLOW_DIR/component/$1

    # Install binary
    sudo cp $SKYFLOW_CACHE_DIR/bin/skyflow-$1.sh /usr/bin/skyflow-$1
    sudo chmod +x /usr/bin/skyflow-$1

    $SKYFLOW_DIR/helper.sh "printSuccess" "$1 component was successfully installed! Now you can use \033[4;94mskyflow-$1\033[0;92m CLI"
    exit 0
}

function skyflowRemove()
{
    componentCacheDir=$SKYFLOW_CACHE_DIR/component/$1

    # Check if component exists
    if [ ! -d $componentCacheDir ] || test -z $1; then
    	$SKYFLOW_DIR/helper.sh "printError" "$1 component not found"
    	exit 1
	fi

    if [ -d $SKYFLOW_DIR/component/$1 ]; then
    	rm -rf $SKYFLOW_DIR/component/$1
	fi

	if [ -f /usr/bin/skyflow-$1 ]; then
    	sudo rm /usr/bin/skyflow-$1
	fi

    $SKYFLOW_DIR/helper.sh "printSuccess" "$1 component was successfully removed!"
    exit 0
}

skyflowInit

case $1 in
    "install")
        skyflowInstall "$2"
    ;;
    "remove")
        skyflowRemove "$2"
    ;;
    "init"|"update")
        skyflowInit "-f"
    ;;
    "-h"|"--help")
        $SKYFLOW_DIR/helper.sh "-h" "Skyflow CLI" "$author" "$docFile"
    ;;
    "-v"|"--version")
        $SKYFLOW_DIR/helper.sh "-v" "$versionMessage" "$author"
    ;;
    *)
        $SKYFLOW_DIR/helper.sh "-h" "Skyflow CLI" "$author" "$docFile"
    ;;
esac

exit 0
