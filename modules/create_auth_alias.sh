#!/usr/bin/env bash

create_auth_alias() {
while (( $# > 0 ))
    do
    case "$1" in
    -n)
    shift
    while [[ $# > 0 ]]; do
        local AUTH_ALIAS_NAME+="${1} "
        if [[ ${2} =~ ^"-" ]]; then
            debugmode echo MINUS DETECTED ${2}
            break
        fi
        shift
    done
    ;;
    -u)
    shift
    local AUTH_ALIAS_USER=${1}
    ;;
    -p)
    shift
    local AUTH_ALIAS_PASSWORD=${1}
    ;;
    -d)
    shift
    while [[ $# > 0 ]]; do
        local AUTH_ALIAS_DESCRIPTION+="${1} "
        if [[ ${2} =~ ^"-" ]]; then
            debugmode echo MINUS DETECTED ${2}
            break
        fi
        shift
    done
    ;;
    *)
    echo "Unknown argument for create_datasource: $1"
    exit 1
    ;;
    esac
    shift
done

    local AUTH_ALIAS_NAME=${AUTH_ALIAS_NAME%?}
    local AUTH_ALIAS_DESCRIPTION=${AUTH_ALIAS_DESCRIPTION%?}

    run_command "AdminTask.createAuthDataEntry('[-alias ${AUTH_ALIAS_NAME} -user ${AUTH_ALIAS_USER} -password \\\"${AUTH_ALIAS_PASSWORD}\\\" -description  ]')"
    save_config
    exit 0
}