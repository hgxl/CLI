#! /bin/bash

source $HOME/.skyflow/helper.sh
source $SKYFLOW_DIR/component/docker/helper.sh

dir=$SKYFLOW_DOCKER_DIR/conf/php
githubDir=$SKYFLOW_GITHUB_CONTENT/component/docker/conf/php

mkdir -p $dir
curl -s "$githubDir/php.ini" -o $dir/php.ini

mkdir -p $dir/conf.d