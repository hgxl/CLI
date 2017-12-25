#! /bin/sh
##! /bin/bash

function printError()
{
    echo -e "\033[0;31mSkyflow error: "$1" \033[0m"
}

function printSuccess()
{
    echo -e "\033[0;92m✓ "$1" \033[0m"
}

function printInfo()
{
    echo -e "\033[0;94m"$1" \033[0m"
}

# Display help for command
# Arguments:
# - $1 : Title
# - $2 : Author
# - $3 : File to use (doc.ini)
function help()
{
    echo
    echo -e "\033[0;96m$1\033[0m\033[0;37m - $2\033[0m"

    start=1
    end=100
    for ((i=$start; i<=$end; i++)); do echo -n -e "\033[0;96m-\033[0m"; done

    echo

    while IFS== read command desc
    do
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
function version()
{
    echo -e "\033[0;96m$1\033[0m"
    echo -e "\033[0;37m$2\033[0m"
}

case $1 in
    "-h")
        help "$2" "$3" "$4"
    ;;
    "-v")
        version "$2" "$3"
    ;;
    "printError")
        printError "$2"
    ;;
    "printSuccess")
        printSuccess "$2"
    ;;
    "printInfo")
        printInfo "$2"
    ;;
esac

exit 0
