#! /bin/sh

if [ "$USER" == "root" ]; then
    echo -e "\033[0;31mSkyflow error: Run without 'root' user.\033[0m"
    exit 1
fi

#source ./helper.sh
source $HOME/.skyflow/helper.sh

export SKYFLOW_FIXTURE_VERSION="1.0.0"
export SKYFLOW_FIXTURE_DIR=$SKYFLOW_DIR/component/fixture

author="Skyflow Team - Franck Diomandé <fkdiomande@gmail.com>"
versionMessage="Skyflow Fixture CLI version $SKYFLOW_FIXTURE_VERSION"
docFile="$SKYFLOW_FIXTURE_DIR/fixture.sdoc"

function skyflowFixtureGenerate()
{
    if ! grep -Fxq "$1" $SKYFLOW_FIXTURE_DIR/fixture.ls; then
        skyflowHelperPrintError "$1 fixture not found"
    	exit 1
    fi

    if [ -d fixture ] && [ "$1" != "-f" ]; then
    	skyflowHelperPrintError "fixture directory already exists. Use -f option to continue"
    	exit 1
	fi
	[ -d fixture ] && sudo rm -rf fixture

	mkdir -p fixture && cd fixture

    mkdir -p $SKYFLOW_FIXTURE_DIR/data/$1

    if [ ! -f $SKYFLOW_FIXTURE_DIR/make/$1.sh ]; then
        skyflowHelperPullFromRemote "component/fixture/make/$1.sh" "$SKYFLOW_FIXTURE_DIR/make/$1.sh"
        sudo chmod +x $SKYFLOW_FIXTURE_DIR/make/$1.sh
    fi
    # Create directories and get files for selected fixture
    [ ! -d $SKYFLOW_FIXTURE_DIR/data/$1 ] && $SKYFLOW_FIXTURE_DIR/make/$1.sh

    DONE=false
    until $DONE; do
        read -u3 line || DONE=true

        # First char
        firstchar=${line:0:1}

        if [ "$firstchar" == "[" ] || [ "$firstchar" == ";" ]; then
            continue
        fi

        key=`expr match "$line" "\([^ ]*\) *= .*"`
        value=`expr match "$line" "$key *= *\(.*\)"`

        read -p "$key [$value] : " newValue

        [ test -z $newValue ] && newValue=$value

	    printf "\033[0;92m✓ %s\033[0m\n" "$newValue"

        [ "$key" == "number" ] && dataNumber=$newValue
        [ "$key" == "data.type" ] && dataType=$newValue
        [ "$key" == "file.name" ] && fileName=$newValue

    done 3< $SKYFLOW_FIXTURE_DIR/fixture.ini

    if [ ! -f $SKYFLOW_FIXTURE_DIR/type/$dataType/$1.tpl ]; then
        mkdir -p $SKYFLOW_FIXTURE_DIR/type/$dataType
        skyflowHelperPullFromRemote "component/fixture/type/$dataType/$1.tpl" "$SKYFLOW_FIXTURE_DIR/type/$dataType/$1.tpl"
    fi

    # Copy template to fixture current directory and change its name
    cp $SKYFLOW_FIXTURE_DIR/type/$dataType/$1.tpl $fileName.$dataType
    sed -i "s/{{ file.name }}/$fileName/g" $fileName.$dataType

#    fixtureCurrentDir=$PWD

    # Get first file
    for firstFile in $(ls $SKYFLOW_FIXTURE_DIR/data/$1); do
        break
    done

    # Count lines in first file
    max=$(skyflowHelperCountFileLines $firstFile)

    # Return to fixture current directory and write random lines number to $1.id file
#    cd fixtureCurrentDir
    [ -f $1.id ] && rm $1.id

    for i in {1..$dataNumber}; do
        random=$(skyflowHelperGetRandomNumber $max)
        printf "%s" "$random" > $1.id
    done


}


# =======================================

case $1 in
    "-h"|"--help")
        skyflowHelperPrintHelp "Skyflow Fixture CLI" "$author" "$docFile"
    ;;
    "-v"|"--version")
        skyflowHelperPrintVersion "$versionMessage" "$author"
    ;;
    "generate")
        skyflowFixtureGenerate "$2"
    ;;
    *)

    ;;
esac

exit 0
