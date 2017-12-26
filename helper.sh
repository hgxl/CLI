#! /bin/sh

function skyflowPrintError()
{
    echo -e "\033[0;31mSkyflow error: "$1" \033[0m"
}

function skyflowPrintSuccess()
{
    echo -e "\033[0;92m✓ "$1" \033[0m"
}

function skyflowPrintInfo()
{
    echo -e "\033[0;94m"$1" \033[0m"
}

function skyflowTrim()
{
    string="$1"
    chars="$2"
    shopt -s extglob
    string="${string##*($chars)}"
    string="${string%%*($chars)}"
    shopt -u extglob
    echo $string
}

# Display help for command
# Arguments:
# - $1 : Ini file
# - $2 : Key
function skyflowGetFromIni()
{
    content=$(cat $1)
#    value=`expr match "$content" ".*$2 *= *\([^'\n''\r']*\)"`
    value=`expr match "$content" ".*$2 *= *\([a-zA-Z0-9_@\.-]*\)"`
    value=$(skyflowTrim $value " /")
    echo -e "$value"
}

# Display help for command
# Arguments:
# - $1 : Title
# - $2 : Author
# - $3 : File to use (doc.ini)
function skyflowHelp()
{
    echo
    echo -e "\033[0;96m$1\033[0m\033[0;37m - $2\033[0m"

    start=1
    end=100
    for ((i=$start; i<=$end; i++)); do echo -n -e "\033[0;96m-\033[0m"; done

    echo

    while IFS== read command desc
    do
        command=$(skyflowTrim $command " ")
        desc=$(skyflowTrim $desc " ")

        # First char
        firstchar=${command:0:1}

        if [ "$firstchar" == "[" ] || [ "$firstchar" == ";" ]; then
            continue
        fi

        # Length
        len=${#command}
        echo -n -e "\033[0;35m$command\033[0m"
        for ((i=1; i<=20-$len; i++)); do echo -n " "; done
        echo -n -e "\033[0;30m$desc\033[0m"
        echo
    done < $3

    echo
}

# Display version for command
# Arguments:
# - $1 : Title
# - $2 : Author
function skyflowVersion()
{
    echo -e "\033[0;96m$1\033[0m"
    echo -e "\033[0;37m$2\033[0m"
}

# Run command
# Arguments:
# - $1 : Command
function skyflowRunCommand()
{
    sudo $1

    if [ $? -eq 0 ]; then
        skyflowPrintSuccess "$1"
        exit 0
    else
        skyflowPrintError "'$1' command failed"
        exit $?
    fi
}

function findDockerComposeFile()
{
    if [ -d docker ] && [ ! -f docker-compose.yml ]; then
        cd docker
    fi

    if [ ! -f docker-compose.yml ]; then
        skyflowPrintError "docker-compose.yml file not found."
        exit 1
    fi
}

case $1 in
    "-h")
        skyflowHelp "$2" "$3" "$4"
    ;;
    "-v")
        skyflowVersion "$2" "$3"
    ;;
    "printError")
        skyflowPrintError "$2"
    ;;
    "printSuccess")
        skyflowPrintSuccess "$2"
    ;;
    "printInfo")
        skyflowPrintInfo "$2"
    ;;
    "trim")
        skyflowTrim "$2" "$3"
    ;;
    "runCommand")
        skyflowRunCommand "$2"
    ;;
    "findComposeFile")
        findDockerComposeFile
    ;;
    "getFromIni")
        skyflowGetFromIni "$2" "$3"
    ;;
esac

exit 0
