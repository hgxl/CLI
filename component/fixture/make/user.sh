#! /bin/bash

source $HOME/.skyflow/helper.sh
export SKYFLOW_FIXTURE_DIR=$SKYFLOW_DIR/component/fixture

mkdir -p ${SKYFLOW_FIXTURE_DIR}/data/user

skyflowHelperPullFromRemote "component/fixture/data/user/avatar.txt" ${SKYFLOW_FIXTURE_DIR}/data/user/avatar.txt
skyflowHelperPullFromRemote "component/fixture/data/user/email.txt" ${SKYFLOW_FIXTURE_DIR}/data/user/email.txt
skyflowHelperPullFromRemote "component/fixture/data/user/firstname.txt" ${SKYFLOW_FIXTURE_DIR}/data/user/firstname.txt
skyflowHelperPullFromRemote "component/fixture/data/user/lastname.txt" ${SKYFLOW_FIXTURE_DIR}/data/user/lastname.txt
skyflowHelperPullFromRemote "component/fixture/data/user/password.txt" ${SKYFLOW_FIXTURE_DIR}/data/user/password.txt