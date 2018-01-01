#! /bin/sh

curl -s https://raw.githubusercontent.com/franckdiomande/Skyflow-cli/master/skyflow.sh >> skyflow4.sh

content=$(cat skyflow4.sh)

if [ "$content" == "404: Not Found" ]; then
    echo "Fail !"
else
    echo "Success !"
fi