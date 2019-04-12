#!/usr/bin/env bash


create_variable() {

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

    run_command "AdminConfig.create('VariableSubstitutionEntry', AdminConfig.getid('${VARIABLE_SCOPE}/VariableMap:/'), '[[symbolicName \\\"${VARIABLE_NAME}\\\"] [description \\\"${VARIABLE_DESCRIPTION}\\\"] [value \\\"${VARIABLE_VALUE}\\\"]]')"

    save_config

    exit 0

}