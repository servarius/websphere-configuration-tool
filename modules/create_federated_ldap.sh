#!/usr/bin/env bash


create_federated_ldap() {

    local REPOSITORY_BASE_REALM=defaultWIMFileBasedRealm
    local REPOSITORY_SET_BY_DEFAULT=0
    local REPOSITORY_ENABLE_ADM_SEC=0
    local REPOSITORY_ENABLE_APP_SEC=0
    local REPOSITORY_ADD_NEW=0

    while (( $# > 0 ))
    do
    case "$1" in
    -n)
    shift
    while [[ $# > 0 ]]; do
        local REPOSITORY_IDENTIFIER+="${1} "
        if [[ ${2} =~ ^"-" ]]; then
            debugmode echo MINUS DETECTED ${2}
            break
        fi
        shift
    done
    local REPOSITORY_ADD_NEW=1
    ;;
    -hn)
    shift
    local REPOSITORY_HOST="${1}"
    ;;
    -hp)
    shift
    local REPOSITORY_HOST_PORT=${1}
    ;;
    -bn)
    shift
    local REPOSITORY_BIND_DN=${1}
    ;;
    -bp)
    shift
    local REPOSITORY_BIND_PASSWORD=${1}
    ;;
    -br)
    shift
    local REPOSITORY_BASE_REALM=${1}
    ;;
    -e)
    shift
    local REPOSITORY_BASE_ENTRY=${1}
    ;;
    -an)
    shift
    local REPOSITORY_BASE_ADMIN_NAME=${1}
    ;;
    -sbd)
    local REPOSITORY_SET_BY_DEFAULT=1
    ;;
    -eas)
    local REPOSITORY_ENABLE_ADM_SEC=1
    ;;
    -eaps)
    local REPOSITORY_ENABLE_APP_SEC=1
    ;;
    *)
    echo "Unknown argument for create_federated_ldap: $1"
    exit 1
    ;;
    esac
    shift
done

    #Var magic
    local REPOSITORY_IDENTIFIER=${REPOSITORY_IDENTIFIER%?}

    if [[ ${REPOSITORY_ADD_NEW} -eq 1 ]]; then
        run_command "AdminTask.createIdMgrLDAPRepository('[-default true -id ${REPOSITORY_IDENTIFIER} -adapterClassName com.ibm.ws.wim.adapter.ldap.LdapAdapter -ldapServerType AD -sslConfiguration  -certificateMapMode exactdn -supportChangeLog none -certificateFilter  -loginProperties uid]')"
        run_command "AdminTask.addIdMgrLDAPServer('[-id ${REPOSITORY_IDENTIFIER} -host \\\"${REPOSITORY_HOST}\\\" -bindDN \\\"${REPOSITORY_BIND_DN}\\\" -bindPassword \\\"${REPOSITORY_BIND_PASSWORD}\\\" -referal ignore -sslEnabled false -ldapServerType AD -sslConfiguration  -certificateMapMode exactdn -certificateFilter  -authentication simple -port ${REPOSITORY_HOST_PORT}]')"
        run_command "AdminTask.addIdMgrRepositoryBaseEntry('[-id ${REPOSITORY_IDENTIFIER} -name ${REPOSITORY_BASE_ENTRY} -nameInRepository ${REPOSITORY_BASE_ENTRY}]')"
        run_command "AdminTask.addIdMgrRealmBaseEntry('[-name ${REPOSITORY_BASE_REALM} -baseEntry ${REPOSITORY_BASE_ENTRY}]')"

    fi

    if [[ ! -z ${REPOSITORY_BASE_ADMIN_NAME} ]]; then
        run_command "AdminTask.validateAdminName('[-registryType WIMUserRegistry -adminUser ${REPOSITORY_BASE_ADMIN_NAME}]')" || exit 1
    fi

    if [[ ${REPOSITORY_SET_BY_DEFAULT} -eq 1 ]]; then
        run_command "AdminTask.setAdminActiveSecuritySettings('[-activeUserRegistry WIMUserRegistry]')" || exit 1
    fi

    if [[ ${REPOSITORY_ENABLE_ADM_SEC} -eq 1 ]]; then
        run_command "AdminTask.setAdminActiveSecuritySettings('[-enableGlobalSecurity true]')" || exit 1
    fi

    if [[ ${REPOSITORY_ENABLE_APP_SEC} -eq 1 ]]; then
        run_command "AdminTask.setAdminActiveSecuritySettings('-appSecurityEnabled true')" || exit 1
    fi

    save_config
    exit 0
 }