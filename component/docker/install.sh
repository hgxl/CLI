#! /bin/bash

source $HOME/.skyflow/helper.sh
skyflowHelperPullFromRemote "component/docker/helper.sh" $SKYFLOW_DIR/component/docker/helper.sh
source $SKYFLOW_DIR/component/docker/helper.sh

[ ! -d $SKYFLOW_DOCKER_DIR/compose ] && mkdir -p $SKYFLOW_DOCKER_DIR/compose
[ ! -d $SKYFLOW_DOCKER_DIR/conf ] && mkdir -p $SKYFLOW_DOCKER_DIR/conf
[ ! -d $SKYFLOW_DOCKER_DIR/container ] && mkdir -p $SKYFLOW_DOCKER_DIR/container
[ ! -d $SKYFLOW_DOCKER_DIR/extra ] && mkdir -p $SKYFLOW_DOCKER_DIR/extra
[ ! -d $SKYFLOW_DOCKER_DIR/list ] && mkdir -p $SKYFLOW_DOCKER_DIR/list
[ ! -d $SKYFLOW_DOCKER_DIR/make ] && mkdir -p $SKYFLOW_DOCKER_DIR/make

skyflowHelperPullFromRemote "component/docker/list/compose.ls" $SKYFLOW_DOCKER_DIR/list/compose.ls
skyflowHelperPullFromRemote "component/docker/list/conf.ls" $SKYFLOW_DOCKER_DIR/list/conf.ls
skyflowHelperPullFromRemote "component/docker/list/container.ls" $SKYFLOW_DOCKER_DIR/list/container.ls
skyflowHelperPullFromRemote "component/docker/list/extra.ls" $SKYFLOW_DOCKER_DIR/list/extra.ls