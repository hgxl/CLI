#! /bin/bash

source $HOME/.skyflow/helper.sh
source $SKYFLOW_DIR/component/docker/helper.sh

dir=$SKYFLOW_DOCKER_DIR/conf/node-slim
githubDir=$SKYFLOW_GITHUB_CONTENT/component/docker/conf/node-slim

mkdir -p $dir
curl -s "$githubDir/Dockerfile" -o $dir/Dockerfile