#! /bin/sh

source $HOME/.skyflow/helper.sh
source $SKYFLOW_DIR/component/docker/helper.sh

dir=$SKYFLOW_DOCKER_DIR/container/apache2
githubDir=$SKYFLOW_GITHUB_CONTENT/component/docker/container/apache2

mkdir -p $dir
curl -s "$githubDir/apache2.ini" -o $dir/apache2.ini
curl -s "$githubDir/apache2.sh" -o $dir/apache2.sh

mkdir -p $dir/default
curl -s "$githubDir/default/docker-compose.yml" -o $dir/default/docker-compose.yml
curl -s "$githubDir/default/Dockerfile" -o $dir/default/Dockerfile

mkdir -p $dir/php
curl -s "$githubDir/php/docker-compose.yml" -o $dir/php/docker-compose.yml
curl -s "$githubDir/php/Dockerfile" -o $dir/php/Dockerfile
