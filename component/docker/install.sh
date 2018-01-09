#! /bin/sh

source $HOME/.skyflow/helper.sh
curl -s "$SKYFLOW_GITHUB_CONTENT/component/docker/helper.sh" -o $SKYFLOW_DIR/component/docker/helper.sh
source $SKYFLOW_DIR/component/docker/helper.sh

[ ! -d $SKYFLOW_DOCKER_DIR/compose ] && mkdir -p $SKYFLOW_DOCKER_DIR/compose
[ ! -d $SKYFLOW_DOCKER_DIR/conf ] && mkdir -p $SKYFLOW_DOCKER_DIR/conf
[ ! -d $SKYFLOW_DOCKER_DIR/container ] && mkdir -p $SKYFLOW_DOCKER_DIR/container
[ ! -d $SKYFLOW_DOCKER_DIR/extra ] && mkdir -p $SKYFLOW_DOCKER_DIR/extra
[ ! -d $SKYFLOW_DOCKER_DIR/list ] && mkdir -p $SKYFLOW_DOCKER_DIR/list
[ ! -d $SKYFLOW_DOCKER_DIR/make ] && mkdir -p $SKYFLOW_DOCKER_DIR/make

curl -s "$SKYFLOW_GITHUB_CONTENT/component/docker/list/compose.ls" -o $SKYFLOW_DOCKER_DIR/list/compose.ls
curl -s "$SKYFLOW_GITHUB_CONTENT/component/docker/list/conf.ls" -o $SKYFLOW_DOCKER_DIR/list/conf.ls
curl -s "$SKYFLOW_GITHUB_CONTENT/component/docker/list/container.ls" -o $SKYFLOW_DOCKER_DIR/list/container.ls
curl -s "$SKYFLOW_GITHUB_CONTENT/component/docker/list/extra.ls" -o $SKYFLOW_DOCKER_DIR/list/extra.ls