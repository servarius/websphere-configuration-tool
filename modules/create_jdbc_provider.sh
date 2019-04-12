#!/usr/bin/env bash


create_jdbc_provider() {
    local ISOLATED_CLASSLOADER=0


    while (( $# > 0 ))
        do
        case "$1" in
        -db)
        shift
        local DB_TYPE=${1}
        ;;
        -n)
        shift
        while [[ $# > 0 ]]; do
            local JDBC_PROVIDER_NAME+="${1} "
            if [[ ${2} =~ ^"-" ]]; then
                debugmode echo MINUS DETECTED ${2}
                break
            fi
            shift
        done
        ;;
        -c)
        shift
        while [[ $# > 0 ]]; do
            local CLASS_PATH+="${1} "
            if [[ ${2} =~ ^"-" ]]; then
                debugmode echo MINUS DETECTED ${2}
                break
            fi
            shift
        done
        ;;
        -nc)
        shift
        while [[ $# > 0 ]]; do
            local NATIVE_PATH+="${1} "
            if [[ ${2} =~ ^"-" ]]; then
                debugmode echo MINUS DETECTED ${2}
                break
            fi
            shift
        done
        ;;
        -d)
        shift
        while [[ $# > 0 ]]; do
            local DESCRIPTION+="${1} "
            if [[ ${2} =~ ^"-" ]]; then
                break
            fi
            shift
        done
        ;;
        -i)
        local ISOLATED_CLASSLOADER=1
        ;;
        *)
        echo "Unknown argument for create_jdbc_provider: $1"
        exit 1
        ;;
        esac
        shift
done


    ##POST_PROC

    local JDBC_PROVIDER_NAME=${JDBC_PROVIDER_NAME%?}
    local CLASS_PATH=${CLASS_PATH%?}
    local NATIVE_PATH=${NATIVE_PATH%?}

    if [[ -z ${DB_TYPE} || -z ${JDBC_PROVIDER_NAME} ]]; then
        echo "Please specify -t and -n"
        exit 1
    fi

    # uncomment for debug
    # echo scope inside create_jdbc_provider ${SCOPE}

    if [[ -z ${JDBC_PROVIDER_SCOPE} ]]; then
        debugmode "You need to specify scope"
        exit 1
    fi

    if [[ ${DB_TYPE} != "oracle" && ${DB_TYPE} != "db2" ]]; then
        debugmode Please choose "oracle" or "db2" as DB_TYPE
        exit 1
    fi

    if [[ ${DB_TYPE} = "oracle" ]]; then
        DB_TYPE="Oracle"
        PROVIDER_TYPE="Oracle JDBC Driver"
        IMPLEMENTATION_TYPE="Connection pool data source"
        IMPLEMENTATION_CLASS="oracle.jdbc.pool.OracleConnectionPoolDataSource"
    fi

    if [[ ${DB_TYPE} = "db2" ]]; then
        DB_TYPE="DB2"
        PROVIDER_TYPE="DB2 Universal JDBC Driver Provider"
        IMPLEMENTATION_TYPE="Connection pool data source"
        IMPLEMENTATION_CLASS="com.ibm.db2.jcc.DB2ConnectionPoolDataSource"

    fi

    local RESULT_COMMAND="AdminTask.createJDBCProvider('[-scope ${JDBC_PROVIDER_SCOPE} -databaseType ${DB_TYPE} -providerType \\\"${PROVIDER_TYPE}\\\" -implementationType \\\"${IMPLEMENTATION_TYPE}\\\" -name \\\"${JDBC_PROVIDER_NAME}\\\" -description \\\"${DESCRIPTION}\\\" -classpath [ ${CLASS_PATH} ] -nativePath \\\"${NATIVE_PATH}\\\" ]')"
    run_command "${RESULT_COMMAND}"

    if [[ ${ISOLATED_CLASSLOADER} -eq 1 ]]; then
        #workaround -- DS_SCOPE from set_scope function.
        local FULL_JDBC_PATH=${DS_SCOPE}/JDBCProvider:${JDBC_PROVIDER_NAME}
        local RESULT_COMMAND="AdminConfig.modify(AdminConfig.getid( '${FULL_JDBC_PATH}'), '[[name \\\"${JDBC_PROVIDER_NAME}\\\"] [implementationClassName \\\"${IMPLEMENTATION_CLASS}\\\"] [isolatedClassLoader "true"] [description \\\"${DESCRIPTION}\\\"]]')"
        run_command "${RESULT_COMMAND}"

    fi

    debugmode example "AdminTask.createJDBCProvider('[-scope Node=DefaultNode01 -databaseType Oracle -providerType \"Oracle JDBC Driver\" -implementationType \"Connection pool data source\" -name \"Sample Oracle Provider\" -description  -classpath [\${ORACLE_JDBC_DRIVER_PATH}/ojdbc14.jar ] -nativePath \"\" ]')"

    debugmode ${RESULT_COMMAND}


    save_config

    exit 0

}