#! /bin/sh

export SKYFLOW_DIR=$HOME/.skyflow
export SKYFLOW_CACHE_DIR=$SKYFLOW_DIR/.cache
export SKYFLOW_VERSION="1.0.0"
export SKYFLOW_GITHUB_URL="https://github.com/skyflow-io/CLI.git"
export SKYFLOW_GITHUB_CONTENT="https://raw.githubusercontent.com/skyflow-io/CLI/master"

# Print skyflow formatted error message
# Arguments:
# - $1 : Message
function skyflowHelperPrintError
{
    echo -e "\033[0;31mSkyflow error: $1\033[0m"
}

# Print skyflow curl failed formatted error message
# Arguments:
# - $1 : Message
function skyflowHelperPrintCurlFailedError
{
    echo -e "\033[0;31mSkyflow error: Can not find the file '$1'.\033[0m"
    echo -e "\033[0;31mPlease check your internet connection and that the file exists.\033[0m"
    exit 1
}

# Pull resources from remote
# Arguments:
# - $1 : Resource path
# - $2 : Output directory
function skyflowHelperPullFromRemote
{
    printf "\033[0;94mPulling\033[0m \033[0;92m%s\033[0m \033[0;94mfrom remote ... \033[0m" "$1"
    curl -s "$SKYFLOW_GITHUB_CONTENT/$1" -o $2
    [ ! $? -eq 0 ] && skyflowHelperPrintCurlFailedError "\n$1"
    printf "\033[0;92mOk\033[0m\n"
}

# Print skyflow formatted success message
# Arguments:
# - $1 : Message
function skyflowHelperPrintSuccess
{
    echo -e "\033[0;92m✓ $1\033[0m"
}

# Print skyflow formatted info message
# Arguments:
# - $1 : Message
function skyflowHelperPrintInfo
{
    echo -e "\033[0;94m$1\033[0m"
}

# Trim string
# Arguments:
# - $1 : string
# - $2 : List of chars
function skyflowHelperTrim
{
    string="$1"
    chars="$2"
    shopt -s extglob
    string="${string##*($chars)}"
    string="${string%%*($chars)}"
    shopt -u extglob
    printf "%s" $string
}

# Display help for command
# Arguments:
# - $1 : Ini file
# - $2 : Key
function skyflowHelperGetFromIni
{
    content=$(cat $1)
    value=`expr match "$content" ".*$2 *= *\([a-zA-Z0-9_@\.-'\"]*\)"`
    value=$(skyflowHelperTrim $value " /")
    printf "%s" "$value"
}

# Display help for command
# Arguments:
# - $1 : Title
# - $2 : Author
# - $3 : File to use ({component}.sdoc)
function skyflowHelperPrintHelp
{
    printf "\n\033[0;96m%s\033[0m\033[0;37m - %s\033[0m\n" "$1" "$2"

    start=1
    end=100
    for ((i=$start; i<=$end; i++)); do printf "\033[0;96m%s\033[0m" "-"; done

    printf "\n"

    DONE=false
    until $DONE; do
        read line || DONE=true

        # First char
        firstchar=${line:0:1}

        if [ "$firstchar" == "[" ] || [ "$firstchar" == ";" ]; then
            continue
        fi

        printf "%s\n" "$line"

    done < $3

    printf "\n"
}

# Display version for command
# Arguments:
# - $1 : Title
# - $2 : Author
function skyflowHelperPrintVersion
{
    printf "\033[0;96m%s\033[0m\n" "$1"
    printf "\033[0;37m%s\033[0m\n" "$2"
}

# Run command
# Arguments:
# - $1 : Command
function skyflowHelperRunCommand
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

# Count lines into file
# Arguments:
# - $1 : File
function skyflowHelperCountFileLines
{
    lc=0
    while read -r line; do
     ((lc++))
    done < $1
    printf "%s" $lc
}

# Get random number between 1 and $1
# Arguments:
# - $1 : Max number
function skyflowHelperGetRandomNumber
{
    rnd=$RANDOM
    let "rnd %= $1"
    ((rnd++))
    printf "%s" $rnd
}

# Get line from file
# Arguments:
# - $1 : File
# - $2 : Number of line
function skyflowHelperGetLineFromFile
{
    i=1
    DONE=false
    until $DONE; do
        read line || DONE=true
        if [ $i -eq $2 ]; then
            break
        fi
        ((i++))
    done < $1

    [ $i -eq $2 ] && printf "%s" $line || printf "%s" ''
}

# Get random line from file
# Arguments:
# - $1 : File
function skyflowHelperGetRandomLineFromFile
{
    n=$(skyflowHelperCountFileLines $1);
    n=$(skyflowHelperGetRandomNumber $n);
    printf "%s" $(skyflowHelperGetLineFromFile $1 $n);
}