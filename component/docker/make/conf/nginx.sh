#! /bin/bash

source $HOME/.skyflow/helper.sh
source $SKYFLOW_DIR/component/docker/helper.sh

dir=$SKYFLOW_DOCKER_DIR/conf/nginx
githubDir=$SKYFLOW_GITHUB_CONTENT/component/docker/conf/nginx

mkdir -p $dir
curl -s "$githubDir/fastcgi.conf" -o $dir/fastcgi.conf
curl -s "$githubDir/fastcgi.conf.default" -o $dir/fastcgi.conf.default
curl -s "$githubDir/nginx.conf" -o $dir/nginx.conf
curl -s "$githubDir/nginx.conf.default" -o $dir/nginx.conf.default

mkdir -p $dir/conf.d
curl -s "$githubDir/conf.d/default.conf" -o $dir/conf.d/default.conf
curl -s "$githubDir/conf.d/default.conf.save" -o $dir/conf.d/default.conf.save