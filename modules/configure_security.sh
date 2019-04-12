#!/usr/bin/env bash

configure_security() {
	local SECURITY_ENABLE_APP_SEC=0
	local SECURITY_ENABLE_ADM_SEC=0
	local SECURITY_ENABLE_SSO=0
	local SECURITY_SSO_DOMAIN=none
	local SECURITY_USER=none
    local SECURITY_FEDERATED_REPO=0
    local SECURITY_MAPUSER=none

    while (( $# > 0 ))
    do
    case "$1" in
    -eas)
    local SECURITY_ENABLE_ADM_SEC=1
    ;;
    -eaps)
    local SECURITY_ENABLE_APP_SEC=1
    ;;
    -ssoe)
	local SECURITY_ENABLE_SSO=1
	;;
    -ssod)
	shift
	local SECURITY_SSO_DOMAIN=${1}
	;;
	-adduser)
	shift
	local SECURITY_USER=${1}
    shift
	local SECURITY_PASSWORD=${1}
	;;
    -sfr)
    local SECURITY_FEDERATED_REPO=1
    ;;
    -mru)
    shift
    local SECURITY_MAPUSER=${1}
    shift
    while [[ $# > 0 ]]; do
            local SECURITY_MAPTOROLE+="${1} "
            if [[ ${2} =~ ^"-" ]]; then
                debugmode echo MINUS DETECTED ${2}
                break
            fi
            shift
        done
    ;;
    *)
    echo "Unknown argument for configure_security: $1"
    exit 1
    ;;
    esac
    shift
done
    
    local SECURITY_MAPTOROLE=${SECURITY_MAPTOROLE%?}


    if [[ ${SECURITY_ENABLE_ADM_SEC} -eq 1 ]]; then
        run_command "AdminTask.setAdminActiveSecuritySettings('[-enableGlobalSecurity true]')" || exit 1
    fi

    if [[ ${SECURITY_ENABLE_APP_SEC} -eq 1 ]]; then
        run_command "AdminTask.setAdminActiveSecuritySettings('-appSecurityEnabled true')" || exit 1
    fi

    if [[ ${SECURITY_SSO_DOMAIN} != none ]]; then
        run_command "AdminTask.configureSingleSignon('-enable true -domainName \\\"${SECURITY_SSO_DOMAIN}\\\"')" || exit 1
    fi

    if [[ ${SECURITY_ENABLE_SSO} -eq 1 ]]; then
        run_command "AdminTask.configureSingleSignon('-enable true')" || exit 1
    fi
    if [[ ${SECURITY_MAPUSER} != none ]]; then
        run_command_soap "username='user:defaultWIMFileBasedRealm/'+AdminTask.searchUsers('-uid ${SECURITY_MAPUSER}');username=\\\"AdminTask.mapUsersToAdminRole('[-accessids [%s ] -userids [%s ] -roleName %s]')\\\" % ( username, '${SECURITY_MAPUSER}', '${SECURITY_MAPTOROLE}'); exec(username)" || exit 1
    fi
    if [[ ${SECURITY_USER} != none ]]; then
        run_command_soap "AdminTask.createUser ('[-uid ${SECURITY_USER} -password ${SECURITY_PASSWORD} -confirmPassword ${SECURITY_PASSWORD} -cn ${SECURITY_USER} -sn ${SECURITY_USER}]')" || exit 1
    fi

    save_config
    exit 0
}