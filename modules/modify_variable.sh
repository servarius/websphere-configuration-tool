#!/usr/bin/env bash

modify_variable() {
while (( $# > 0 ))
    do
    case "$1" in
    -n)
    shift
    local VARIABLE_NAME=${1}
    ;;
    -v)
    shift
    local VARIABLE_VALUE="${1}"
    ;;
    -d)
    shift
    while [[ $# > 0 ]]; do
        local VARIABLE_DESCRIPTION+="${1} "
        if [[ ${2} =~ ^"-" ]]; then
            debugmode echo MINUS DETECTED ${2}
            break
        fi
        shift
    done
    ;;
    *)
    echo "Unknown argument for create_variable: $1"
    exit 1
    ;;
    esac
    shift
done
    local VARIABLE_DESCRIPTION=${VARIABLE_DESCRIPTION%?}

    ### For debug ! AdminTask.showVariables('[ -scope Cell -variableName DERBY_JDBC_DRIVER_PATH ]')

    run_command "AdminTask.setVariable('[-variableName ${VARIABLE_NAME} -scope ${VARIABLE_MODIFY_SCOPE} -variableValue ${VARIABLE_VALUE} -variableDescription \\\"${VARIABLE_DESCRIPTION}\\\"]')"

    save_config

    exit 0

}