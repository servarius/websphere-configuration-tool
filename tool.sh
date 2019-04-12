#!/usr/bin/env bash

TOOL_PATH=$(dirname $(which tool.sh))
[[ ! -z ${TOOL_PATH} ]] && TOOL_FULL_PATH=${TOOL_PATH}/
### Create JDBC Provider

DEBUG_MODE=0

check_err() {
    local status=$?
    if [ ! $status -eq "0" ]
    then
        echo "There is an error $status"
        exit $status
    fi 
}

debugmode() {
    if [[ ! ${DEBUG_MODE} -eq 0 ]]; then
        echo "${@}"
    fi
}


source ${TOOL_FULL_PATH}modules/show_help.sh


args_empty() {
    if [[ $# == 0 ]]; then
        debugmode "There is some empty ARGS. Check it or use --DEBUG mode"
        show_help
        exit 1
    fi
}


run_command() {

    local COMMAND_NAME=${@}

    local RESULT_COMMAND="wsadmin.sh -lang jython -conntype NONE -c \"${COMMAND_NAME}\""

    debugmode ${RESULT_COMMAND}

    eval ${RESULT_COMMAND}

    check_err
}


run_command_soap() {

    local COMMAND_NAME=${@}

    if [[ ${SOAP_HOSTNAME} != none && ${SOAP_PORT} != none ]]; then
        #statements
        local RESULT_COMMAND="wsadmin.sh -lang jython -conntype SOAP -host ${SOAP_HOSTNAME} -port ${SOAP_PORT} -user ${SOAP_USERNAME} -password ${SOAP_PASSWORD} -c \"${COMMAND_NAME}\""
    fi

    if [[ ${SOAP_HOSTNAME} == none && ${SOAP_PORT} != none ]]; then
        local RESULT_COMMAND="wsadmin.sh -lang jython -conntype SOAP -user ${SOAP_USERNAME} -password ${SOAP_PASSWORD} -port ${SOAP_PORT} -c \"${COMMAND_NAME}\""
    else
        local RESULT_COMMAND="wsadmin.sh -lang jython -conntype SOAP -user ${SOAP_USERNAME} -password ${SOAP_PASSWORD} -c \"${COMMAND_NAME}\""
    fi
    

    debugmode ${RESULT_COMMAND}

    eval ${RESULT_COMMAND}

    check_err
}




source ${TOOL_FULL_PATH}modules/get_id.sh


save_config() {
    run_command "AdminConfig.save()"
}

set_scope() {
    SCOPE=${1}
    args_empty ${SCOPE}
    if [[ ${SCOPE} == "server" ]]; then
        SCOPE="server"
        JDBC_PROVIDER_SCOPE="Cell=${CELL_NAME},Node=${NODE_NAME},Server=${SERVER_NAME}"
        DS_SCOPE="/Cell:${CELL_NAME}/Node:${NODE_NAME}/Server:${SERVER_NAME}"
    fi
    if [[ ${SCOPE} == "node" ]]; then
        SCOPE="node"
        JDBC_PROVIDER_SCOPE="Cell=${CELL_NAME},Node=${NODE_NAME}"
        DS_SCOPE="/Cell:${CELL_NAME}/Node:${NODE_NAME}"
    fi
    if [[ ${SCOPE} == "cluster" ]]; then
        SCOPE="cluster"
        JDBC_PROVIDER_SCOPE="Cluster=${CLUSTER_NAME}"
        DS_SCOPE="/ServerCluster:${CLUSTER_NAME}"
    fi
    if [[ ${SCOPE} == "cell" ]]; then
        SCOPE="cell"
        JDBC_PROVIDER_SCOPE="Cell=${CELL_NAME}"
        DS_SCOPE="/Cell:${CELL_NAME}"
    fi



    VARIABLE_SCOPE=${DS_SCOPE}
    VARIABLE_MODIFY_SCOPE=${JDBC_PROVIDER_SCOPE}
    SHAREDLIB_SCOPE=${DS_SCOPE}

    debugmode scope is ${SCOPE}
}

source ${TOOL_FULL_PATH}modules/create_jdbc_provider.sh

source ${TOOL_FULL_PATH}modules/create_auth_alias.sh

source ${TOOL_FULL_PATH}modules/create_datasource.sh

source ${TOOL_FULL_PATH}modules/create_variable.sh

source ${TOOL_FULL_PATH}modules/modify_variable.sh

source ${TOOL_FULL_PATH}modules/create_shared_lib.sh

source ${TOOL_FULL_PATH}modules/create_federated_ldap.sh

source ${TOOL_FULL_PATH}modules/configure_security.sh

source ${TOOL_FULL_PATH}modules/deploy_app.sh

run_task() {
    local TASKNAME=${1}
    args_empty ${TASKNAME}
    ARGS_FOR_TASK=${*:2}
    debugmode ARGS_FOR_TASK= ${ARGS_FOR_TASK}

    if [[ ${TASKNAME} == create_jdbc_provider ]]; then
        create_jdbc_provider ${ARGS_FOR_TASK}
    fi

    if [[ ${TASKNAME} == create_auth_alias ]]; then
        create_auth_alias ${ARGS_FOR_TASK}
    fi

    if [[ ${TASKNAME} == create_datasource ]]; then
        create_datasource ${ARGS_FOR_TASK}
    fi

    if [[ ${TASKNAME} == create_federated_ldap ]]; then
        create_federated_ldap ${ARGS_FOR_TASK}
    fi

    if [[ ${TASKNAME} == create_shared_lib ]]; then
        create_shared_lib ${ARGS_FOR_TASK}
    fi

    if [[ ${TASKNAME} == create_variable ]]; then
        create_variable ${ARGS_FOR_TASK}
    fi

    if [[ ${TASKNAME} == modify_variable ]]; then
        modify_variable ${ARGS_FOR_TASK}
    fi

    if [[ ${TASKNAME} == save_config ]]; then
        save_config ${ARGS_FOR_TASK}
    fi

    if [[ ${TASKNAME} == get_id ]]; then
        get_id ${ARGS_FOR_TASK}
    fi

    if [[ ${TASKNAME} == configure_security ]]; then
        configure_security ${ARGS_FOR_TASK}
    fi

    if [[ ${TASKNAME} == deploy_app ]]; then
        deploy_app ${ARGS_FOR_TASK}
    fi
        
}

source ${TOOL_FULL_PATH}modules/menu.sh
menu ${@}