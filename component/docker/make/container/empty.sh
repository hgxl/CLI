#! /bin/sh

source $HOME/.skyflow/helper.sh
source $SKYFLOW_DIR/component/docker/helper.sh

dir=$SKYFLOW_DOCKER_DIR/container/empty
githubDir=$SKYFLOW_GITHUB_CONTENT/component/docker/container/empty

mkdir -p $dir
curl -s "$githubDir/empty.ini" -o $dir/empty.ini
curl -s "$githubDir/empty.sh" -o $dir/empty.sh
curl -s "$githubDir/docker-compose.yml" -o $dir/docker-compose.yml
