#! /bin/sh

export SKYFLOW_DIR=$HOME/.skyflow
export SKYFLOW_CACHE_DIR=$SKYFLOW_DIR/.cache
export SKYFLOW_VERSION="1.0.0"
export SKYFLOW_GITHUB_URL="https://github.com/franckdiomande/Skyflow-cli.git"

# Print skyflow formatted error message
# Arguments:
# - $1 : Message
function skyflowHelperPrintError()
{
    echo -e "\033[0;31mSkyflow error: $1\033[0m"
}

# Print skyflow formatted success message
# Arguments:
# - $1 : Message
function skyflowHelperPrintSuccess()
{
    echo -e "\033[0;92m✓ $1\033[0m"
}

# Print skyflow formatted info message
# Arguments:
# - $1 : Message
function skyflowHelperPrintInfo()
{
    echo -e "\033[0;94m$1\033[0m"
}

# Trim string
# Arguments:
# - $1 : string
# - $2 : List of chars
function skyflowHelperTrim()
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
function skyflowHelperGetFromIni()
{
    content=$(cat $1)
#    value=`expr match "$content" ".*$2 *= *\([a-zA-Z0-9_@\.-'\"]*\)"`
    value=`expr match "$content" "$2 *= *\(.*\)"`
    value=$(skyflowHelperTrim $value " /")
    echo -e "$value"
}

# Display help for command
# Arguments:
# - $1 : Title
# - $2 : Author
# - $3 : File to use (doc.ini)
function skyflowHelperPrintHelp()
{
    echo
    echo -e "\033[0;96m$1\033[0m\033[0;37m - $2\033[0m"

    start=1
    end=100
    for ((i=$start; i<=$end; i++)); do echo -n -e "\033[0;96m-\033[0m"; done

    echo

    while read line
    do
        # First char
        firstchar=${line:0:1}

        if [ "$firstchar" == "[" ] || [ "$firstchar" == ";" ]; then
            continue
        fi

        key=`expr match "$line" "\([^=]*\) *= .*"`
        value=`expr match "$line" "$key *= *\(.*\)"`

        # Length
        len=${#key}
        echo -n -e "\033[0;35m$key\033[0m"
        for ((i=1; i<=35-$len; i++)); do echo -n " "; done
        echo -n -e "\033[0;30m$value\033[0m"
        echo
    done < $3

    echo
}

# Display version for command
# Arguments:
# - $1 : Title
# - $2 : Author
function skyflowHelperPrintVersion()
{
    echo -e "\033[0;96m$1\033[0m"
    echo -e "\033[0;37m$2\033[0m"
}

# Run command
# Arguments:
# - $1 : Command
function skyflowHelperRunCommand()
{
    sudo $1

    if [ $? -eq 0 ]; then
        skyflowHelperPrintSuccess "$1"
        exit 0
    else
        skyflowHelperPrintError "'$1' command failed"
        exit $?
    fi
}
