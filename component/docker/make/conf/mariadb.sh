#! /bin/sh

source $HOME/.skyflow/helper.sh
source $SKYFLOW_DIR/component/docker/helper.sh

dir=$SKYFLOW_DOCKER_DIR/conf/mariadb
githubDir=$SKYFLOW_GITHUB_CONTENT/component/docker/conf/mariadb

mkdir -p $dir
curl -s "$githubDir/debian.cnf" -o $dir/debian.cnf
curl -s "$githubDir/debian-start" -o $dir/debian-start
curl -s "$githubDir/my.cnf" -o $dir/my.cnf

mkdir -p $dir/conf.d
curl -s "$githubDir/conf.d/docker.cnf" -o $dir/conf.d/docker.cnf
curl -s "$githubDir/conf.d/mariadb.cnf" -o $dir/conf.d/mariadb.cnf
curl -s "$githubDir/conf.d/mysqld_safe_syslog.cnf" -o $dir/conf.d/mysqld_safe_syslog.cnf