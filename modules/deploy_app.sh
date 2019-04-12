#!/usr/bin/env bash

deploy_app() {
    local local DEPLOYAPP_CLASSLOADER=none
    local DEPLOYAPP_TRUE=false

    while (( $# > 0 ))
    do
    case "$1" in
    -d)
    local DEPLOYAPP_TRUE=true
    ;;
    -n)
	shift
    local DEPLOYAPP_APP_NAME=${1}
    ;;
    -p)
	shift
	local DEPLOYAPP_APP_PATH=${1}
	;;
    -cr)
	shift
    local DEPLOYAPP_CONTEXT_ROOT=${1}
	;;
    -prntl)
    local DEPLOYAPP_CLASSLOADER=PARENT_LAST
    ;;
    -prntf)
    local DEPLOYAPP_CLASSLOADER=PARENT_FIRST
    ;;
    *)
    echo "Unknown argument for deploy_app: $1"
    exit 1
    ;;
    esac
    shift
done


if [[ ${DEPLOYAPP_TRUE} != false ]]; then
        run_command "AdminApp.install('${DEPLOYAPP_APP_PATH}', '[  -appname ${DEPLOYAPP_APP_NAME} -contextroot ${DEPLOYAPP_CONTEXT_ROOT}  ]' )" || exit 1
fi

if [[ ${DEPLOYAPP_CLASSLOADER} != none ]]; then
        run_command "AdminConfig.modify(AdminConfig.showAttribute(AdminConfig.showAttribute(AdminConfig.getid('/Deployment:${DEPLOYAPP_APP_NAME}/'), 'deployedObject'), 'classloader'), [['mode', '${DEPLOYAPP_CLASSLOADER}']])" || exit 1
fi



}

