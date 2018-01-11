#! /bin/sh

source $HOME/.skyflow/helper.sh
export SKYFLOW_FIXTURE_DIR=$SKYFLOW_DIR/component/fixture

[ ! -d ${SKYFLOW_FIXTURE_DIR}/assets ] && mkdir -p ${SKYFLOW_FIXTURE_DIR}/assets
[ ! -d ${SKYFLOW_FIXTURE_DIR}/data ] && mkdir -p ${SKYFLOW_FIXTURE_DIR}/data
[ ! -d ${SKYFLOW_FIXTURE_DIR}/make ] && mkdir -p ${SKYFLOW_FIXTURE_DIR}/make
[ ! -d ${SKYFLOW_FIXTURE_DIR}/type ] && mkdir -p ${SKYFLOW_FIXTURE_DIR}/type

skyflowHelperPullFromRemote "component/fixture/fixture.ini" ${SKYFLOW_FIXTURE_DIR}/fixture.ini
skyflowHelperPullFromRemote "component/fixture/fixture.ls" ${SKYFLOW_FIXTURE_DIR}/fixture.ls