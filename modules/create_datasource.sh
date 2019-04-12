#!/usr/bin/env bash

create_datasource() {

    local DS_CMP="false"

while (( $# > 0 ))
    do
    case "$1" in
    -j)
    shift
    local DS_JNDI_NAME=${1}
    ;;
    -n)
    shift
    while [[ $# > 0 ]]; do
        local DS_NAME+="${1} "
        if [[ ${2} =~ ^"-" ]]; then
            debugmode echo MINUS DETECTED ${2}
            break
        fi
        shift
    done
    ;;
    -authAlias)
    shift
    local DS_AUTH_ALIAS+="${1}"
    ;;
    -helper)
    shift
    local DS_HELPER="${1}"
    ;;
    -CMP)
    local DS_CMP="true"
    ;;
    -u)
    shift
    while [[ $# > 0 ]]; do
        local DS_URL+="${1} "
        if [[ ${2} =~ ^"-" ]]; then
            debugmode echo MINUS DETECTED ${2}
            break
        fi
        shift
    done
    ;;
    -p)
    shift
    while [[ $# > 0 ]]; do
        local DS_PROVIDER_NAME+="${1} "
        if [[ ${2} =~ ^"-" ]]; then
            debugmode echo MINUS DETECTED ${2}
            break
        fi
        shift
    done
    ;;
    -db)
    shift
    local DS_TYPE=${1}
    ;;
    *)
    echo "Unknown argument for create_datasource: $1"
    exit 1
    ;;
    esac
    shift
done

    ##Some VAR magic

    local DS_NAME=${DS_NAME%?}
    local DS_PROVIDER_NAME="${DS_PROVIDER_NAME%?}/"
    # local DS_AUTH_ALIAS=${NODE_NAME}/${DS_AUTH_ALIAS}
    local DS_AUTH_ALIAS=${DS_AUTH_ALIAS}
    local DS_URL=${DS_URL%?}
    local FULL_JDBC_PATH=${DS_SCOPE}/JDBCProvider:${DS_PROVIDER_NAME}
    local FULL_DS_PATH="${FULL_JDBC_PATH}DataSource:${DS_NAME}/"
    local DS_CONNECTOR_FACTORY="${DS_NAME}_CF"

    if [[ -z ${DS_SCOPE} ]]; then
        debugmode "You need to specify scope"
        exit 1
    fi

    if [[ ${DS_TYPE} -eq "db2" ]]; then
        set -- ${DS_URL}
        local DS_DB2_NAME=${1}
        local DS_DB2_SERVER_NAME=${2}
        local DS_DB2_PORT=${3}
    fi

    ##A little trick to set Helper class

    if [[ ${DS_HELPER} =~ ^"oracle11" ]]; then
        local DS_HELPER="com.ibm.websphere.rsadapter.Oracle11gDataStoreHelper"
    fi

    if [[ ${DS_HELPER} =~ ^"oracle10" ]]; then
        local DS_HELPER="com.ibm.websphere.rsadapter.Oracle10gDataStoreHelper"
    fi

    if [[ ${DS_HELPER} =~ ^"db2" ]]; then
        local DS_HELPER="com.ibm.websphere.rsadapter.DB2UniversalDataStoreHelper"
    fi

    if [[ ${DS_TYPE} == "oracle" ]]; then
        debugmode ${DS_TYPE}
        run_command "AdminTask.createDatasource(AdminConfig.getid( '${FULL_JDBC_PATH}'), '[-name \\\"${DS_NAME}\\\" -jndiName ${DS_JNDI_NAME} -dataStoreHelperClassName ${DS_HELPER} -containerManagedPersistence ${DS_CMP} -componentManagedAuthenticationAlias ${DS_AUTH_ALIAS} -configureResourceProperties [[URL java.lang.String ${DS_URL}]]]')"

    fi

    if [[ ${DS_TYPE} == "db2" ]]; then
        run_command "AdminTask.createDatasource(AdminConfig.getid( '${FULL_JDBC_PATH}'), '[-name \\\"${DS_NAME}\\\" -jndiName ${DS_JNDI_NAME} -dataStoreHelperClassName ${DS_HELPER} -containerManagedPersistence ${DS_CMP} -componentManagedAuthenticationAlias ${DS_AUTH_ALIAS} -configureResourceProperties [[databaseName java.lang.String ${DS_DB2_NAME}] [driverType java.lang.Integer 4] [serverName java.lang.String ${DS_DB2_SERVER_NAME}] [portNumber java.lang.Integer ${DS_DB2_PORT}]]]')"
    fi


    run_command "AdminConfig.create('MappingModule', AdminConfig.getid( '${FULL_DS_PATH}'), '[[authDataAlias ${DS_AUTH_ALIAS}] [mappingConfigAlias \\\"\\\"]]')"

    run_command "AdminConfig.modify(AdminConfig.getid('/CMPConnectorFactory:${DS_CONNECTOR_FACTORY}/'), '[[name \\\"${DS_CONNECTOR_FACTORY}\\\"] [authDataAlias \\\"${DS_AUTH_ALIAS}\\\"] [xaRecoveryAuthAlias \\\"\\\"]]')"

    run_command "AdminConfig.create('MappingModule', AdminConfig.getid('/CMPConnectorFactory:${DS_CONNECTOR_FACTORY}/'), '[[authDataAlias ${DS_AUTH_ALIAS}] [mappingConfigAlias \\\"\\\"]]')"


    save_config
    exit 0

}