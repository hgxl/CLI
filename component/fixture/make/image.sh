#! /bin/bash

source $HOME/.skyflow/helper.sh
export SKYFLOW_FIXTURE_DIR=$SKYFLOW_DIR/component/fixture

mkdir -p ${SKYFLOW_FIXTURE_DIR}/data/image

skyflowHelperPullFromRemote "component/fixture/data/image/name.txt" ${SKYFLOW_FIXTURE_DIR}/data/image/name.txt
skyflowHelperPullFromRemote "component/fixture/data/image/path.txt" ${SKYFLOW_FIXTURE_DIR}/data/image/path.txt