#! /bin/sh

source $HOME/.skyflow/helper.sh
source $SKYFLOW_DIR/component/docker/helper.sh

dir=$SKYFLOW_DOCKER_DIR/extra/php
githubDir=$SKYFLOW_GITHUB_CONTENT/component/docker/extra/php

mkdir -p $dir/modules