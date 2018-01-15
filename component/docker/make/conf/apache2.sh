#! /bin/bash

source $HOME/.skyflow/helper.sh
source $SKYFLOW_DIR/component/docker/helper.sh

dir=$SKYFLOW_DOCKER_DIR/conf/apache2
githubDir=$SKYFLOW_GITHUB_CONTENT/component/docker/conf/apache2

mkdir -p $dir/default
curl -s "$githubDir/default/httpd.conf" -o $dir/default/httpd.conf
curl -s "$githubDir/default/magic" -o $dir/default/magic
curl -s "$githubDir/default/mime.types" -o $dir/default/mime.types

mkdir -p $dir/default/conf.d
curl -s "$githubDir/default/conf.d/default.conf" -o $dir/default/conf.d/default.conf
curl -s "$githubDir/default/conf.d/info.conf" -o $dir/default/conf.d/info.conf
curl -s "$githubDir/default/conf.d/languages.conf" -o $dir/default/conf.d/languages.conf
curl -s "$githubDir/default/conf.d/mpm.conf" -o $dir/default/conf.d/mpm.conf
curl -s "$githubDir/default/conf.d/userdir.conf" -o $dir/default/conf.d/userdir.conf

mkdir -p $dir/php/conf.d
curl -s "$githubDir/php/conf.d/php5-module.conf" -o $dir/php/conf.d/php5-module.conf
curl -s "$githubDir/php/conf.d/php7-module.conf" -o $dir/php/conf.d/php7-module.conf