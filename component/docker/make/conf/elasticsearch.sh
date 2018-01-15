#! /bin/bash

source $HOME/.skyflow/helper.sh
source $SKYFLOW_DIR/component/docker/helper.sh

dir=$SKYFLOW_DOCKER_DIR/conf/elasticsearch
githubDir=$SKYFLOW_GITHUB_CONTENT/component/docker/conf/elasticsearch

mkdir -p $dir/nodes/0/_state
curl -s "$githubDir/nodes/0/_state/global-0.st" -o $dir/nodes/0/_state/global-0.st
curl -s "$githubDir/nodes/0/_state/node-0.st" -o $dir/nodes/0/_state/node-0.st

curl -s "$githubDir/nodes/0/node.lock" -o $dir/nodes/0/node.lock
