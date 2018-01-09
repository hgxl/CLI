#! /bin/sh

source $HOME/.skyflow/helper.sh
source $SKYFLOW_DIR/component/docker/helper.sh

dir=$SKYFLOW_DOCKER_DIR/container/nginx
githubDir=$SKYFLOW_GITHUB_CONTENT/component/docker/container/nginx

mkdir -p $dir
curl -s "$githubDir/nginx.ini" -o $dir/nginx.ini
curl -s "$githubDir/nginx.sh" -o $dir/nginx.sh
curl -s "$githubDir/docker-compose.yml" -o $dir/docker-compose.yml
