#! /bin/sh

source $HOME/.skyflow/helper.sh
source $SKYFLOW_DIR/component/docker/helper.sh

dir=$SKYFLOW_DOCKER_DIR/conf/phpmyadmin
githubDir=$SKYFLOW_GITHUB_CONTENT/component/docker/conf/phpmyadmin

mkdir -p $dir
curl -s "$githubDir/config.inc.php" -o $dir/config.inc.php
curl -s "$githubDir/config.secret.inc.php" -o $dir/config.secret.inc.php
curl -s "$githubDir/config.user.inc.php" -o $dir/config.user.inc.php
