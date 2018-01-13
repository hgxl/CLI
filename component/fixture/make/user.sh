#! /bin/sh

source $HOME/.skyflow/helper.sh
export SKYFLOW_FIXTURE_DIR=$SKYFLOW_DIR/component/fixture

mkdir -p ${SKYFLOW_FIXTURE_DIR}/data/company

skyflowHelperPullFromRemote "component/fixture/data/company/country.txt" ${SKYFLOW_FIXTURE_DIR}/data/company/country.txt
skyflowHelperPullFromRemote "component/fixture/data/company/description.txt" ${SKYFLOW_FIXTURE_DIR}/data/company/description.txt
skyflowHelperPullFromRemote "component/fixture/data/company/logo.txt" ${SKYFLOW_FIXTURE_DIR}/data/company/logo.txt
skyflowHelperPullFromRemote "component/fixture/data/company/name.txt" ${SKYFLOW_FIXTURE_DIR}/data/company/name.txt
skyflowHelperPullFromRemote "component/fixture/data/company/sector.txt" ${SKYFLOW_FIXTURE_DIR}/data/company/sector.txt
skyflowHelperPullFromRemote "component/fixture/data/company/turnover.txt" ${SKYFLOW_FIXTURE_DIR}/data/company/turnover.txt