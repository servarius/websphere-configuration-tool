#!/usr/bin/env bash


show_help() {

    if [[ $# == 0 ]]; then
        cat << INFO

            HELP_INFO
            ---------
            Please enter one or more of the following options:

            ${0} -h | --help
            ${0} -h modulename | --help ###for list modules type "-h modules"
            ${0} -m | --mode ##server | node | cell
            ${0} -f | --file ##specify the filename with parameters
            ${0} -t | --taskname ## -s server -S server1 -N Node01 -C Cell01 -t create_jdbc_provider -n....
            ${0} -s | --set-scope ## -s server server1
            -Cl | --ClusterName
            -S | --ServerName
            -N | --NodeName
            -C | --CellName
            --DEBUG #for debug mode ON use it BEFORE all args in command line

            For SOAP tasks:

            -port 8880 #SOAP port
            -user wsadmin #Admin user
            -password Password #Admin password
            -host hostname (OPTIONAL) #Default is localhost

INFO
    fi


    if [[ ${1} == modules || ${1} == module || ${1} == modulename ]]; then
        cat << MODULES

            LIST of MODULES
            --------------------------------------------------
            Please enter one or more of the following options:

            create_jdbc_provider
            create_auth_alias
            create_datasource
            create_variable
            modify_variable
            create_shared_lib
            create_federated_ldap
            configure_security




MODULES
    fi


    if [[ ${1} == create_jdbc_provider ]]; then
        cat << CREATE_JDBC_PROVIDER

            HELP fro module create_jdbc_provider
            --------------------------------------------------
            Please enter one or more of the following options:

            ${0} -h | --help
            ${0} -h modulename | --help ###for list modules type "-h modules"

            -db (oracle || db2) ## Type of JDBC provider# -t oracle
            -n "provider name"
            -c '\${SOMEVAR}/for/libs/'
            -nc 'native classpath for libs' #OPTIONAL
            -d "Descrip tion" #Description
            -i ## ISOLATED CLASS LOADER (OPTIONAL)

            for example: ${0} -C Cell01 -s cell -t create_jdbc_provider -db oracle -n My JDBC Provider -c '\\\${KAPITOSHKA}/libs \\\${ANOTHER_VAR}/some'  -d Some info

CREATE_JDBC_PROVIDER
    fi

    if [[ ${1} == create_datasource ]]; then
        cat << CREATE_DATASOURCE

            HELP fro module create_jdbc_provider
            --------------------------------------------------
            Please enter one or more of the following options:

            ${0} -h | --help
            ${0} -h modulename | --help ###for list modules type "-h modules"

            -db oracle || db2 ## Type of Datasource
            -n Datasource Name
            -j jdbc/jndiName
            -authAlias Nodename/AuthAlias
            -helper com.ibm.Helper.class ### -helper oracle10 || oracle11 generates default helper classes
            -CMP ### Use this DS in container-managed persistence (CMP)
            -u jdbc:some:oracle url  ### If -t oracle


            -u BASENAME SERVERNAME PORT ## If -t db2
            -p jdbcProviderName ## Use this with -s cell -C Cell01 option!!


            for example: ${0} -C Cell01 -s cell -C DefaultCell01 -t create_datasource -db oracle -n Datasource Name -j jdbc/myDS  -authAlias Node01/someAuth -helper oracle10 -u jdbc:server:sampledb:1521 -i

            OR for DB2: ${0} -C Cell01 -s cell -C DefaultCell01 -t create_datasource -db db2 -n Datasource Name -j jdbc/myDS  -authAlias Node01/someAuth -helper db2 -u DB2BASE SERVER 50001 -i

CREATE_DATASOURCE
    fi

    if [[ ${1} == create_auth_alias ]]; then
        cat << CREATE_AUTH_ALIAS

            HELP fro module create_auth_alias
            --------------------------------------------------
            Please enter one or more of the following options:

            ${0} -h | --help
            ${0} -h modulename | --help ###for list modules type "-h modules"

            -n Auth Alias Name
            -u username
            -p password for username
            -d description (OPTIONAL)




            for example: ${0} -t create_auth_alias -n someAuthName -u someOracleUser  -p 'Pa\\\$\\\$word' -d auth alias

CREATE_AUTH_ALIAS
    fi


    if [[ ${1} == create_variable ]]; then
        cat << CREATE_VARIABLE

            HELP fro module create_variable
            --------------------------------------------------
            Please enter one or more of the following options:

            ${0} -h | --help
            ${0} -h modulename | --help ###for list modules type "-h modules"

            -n varName
            -v Variable value
            -d description (OPTIONAL)




            for example: ${0} -s node -C DefaultCell01 -N DefaultNode01 -t create_variable  -n SampleVar -v /opt/samplepath -d The most important var

CREATE_VARIABLE
    fi

    if [[ ${1} == modify_variable ]]; then
        cat << MODIFY_VARIABLE

            HELP fro module modify_variable
            --------------------------------------------------
            Please enter one or more of the following options:

            ${0} -h | --help
            ${0} -h modulename | --help ###for list modules type "-h modules"

            -n varName
            -v Variable value
            -d description (OPTIONAL)




            for example: ${0} -s node -C DefaultCell01 -N DefaultNode01 -t modify_variable  -n SampleVar -v /opt/samplepath -d The most important var

MODIFY_VARIABLE
    fi

    if [[ ${1} == create_shared_lib ]]; then
        cat << CREATE_SHARED_LIB

            HELP fro module create_shared_lib
            --------------------------------------------------
            Please enter one or more of the following options:

            ${0} -h | --help
            ${0} -h modulename | --help ###for list modules type "-h modules"

            -n SharedLibName
            -cp '\${CLASSPATH}/classpath/name \${ANOTHERVAR}'
            -np '\${NATIVEPATH}/nativepath/name \${ANOTHERVAR}'
            -i isolated classloader (OPTIONAL)
            -d description (OPTIONAL)


            for example: ${0} -s node -C DefaultCell01 -N DefaultNode01 -t create_shared_lib  -n SampleSharedLib -cp '\\\${SampleSharedLib_PATH}/lib\;\\\${SampleSharedLib_PATH}/some.properties'

CREATE_SHARED_LIB
    fi

    if [[ ${1} == create_federated_ldap ]]; then
        cat << CREATE_FEDERATED_LDAP

            HELP fro module create_federated_ldap
            --------------------------------------------------
            Please enter one or more of the following options:

            ${0} -h | --help
            ${0} -h modulename | --help ###for list modules type "-h modules"

            -n RepositoryIdentifiername #e.g. -n domain_com
            -hn catalog.hostname.domain.com
            -hp 3268
            -bn cn=bindUser,dc=domain,dc=com
            -bp Pa\\\$\\\$word ## bind password
            -e dc=domain,dc=com ###Base entry
            -br Wim_Base_Realm (OPTIONAL) # Default is defaultWIMFileBasedRealm
            -an PrimaryAdminName (OPTIONAL)
            -sbd (OPTIONAL) ##Sets By Default Federated Repo
            -eas (OPTIONAL) ##Enables Administrative security.
            -eaps (OPTIONAL) ##Enables Application security.




            for example: ${0} -t create_federated_ldap -n domain_com -hn dcp.portal.domain.com -hp 3268 -bn cn=user,dc=domain,dc=com -bp ExampleStrongPassword -e dc=domain,dc=com

CREATE_FEDERATED_LDAP
    fi

    if [[ ${1} == configure_security ]]; then
        cat << CONFIGURE_SECURITY

            HELP fro module configure_security
            --------------------------------------------------
            Please enter one or more of the following options:

            ${0} -h | --help
            ${0} -h modulename | --help ###for list modules type "-h modules"

            -adduser username password (OPTIONAL) # Adds local user "username"
            -eas (OPTIONAL) ##Enables Administrative security.
            -eaps (OPTIONAL) ##Enables Application security.
            -ssoe ##Enables SSO
            -ssod .domain.com #Sets Domain Name for SSO in Global Security->SSO
            -sfr ##Setting Federated Repo As Defalt
            -mru username rolename #Map Role to User.
                    Available roles: administrator | configurator | operator | deployer | monitor 


            for example: ${0} -t configure_security -ssod .domain.com -eas -eaps -ssoe

CONFIGURE_SECURITY
    fi

    if [[ ${1} == deploy_app ]]; then
        cat << DEPLOY_APP

            HELP fro module deploy_app
            --------------------------------------------------
            Please enter one or more of the following options:

            ${0} -h | --help
            ${0} -h modulename | --help ###for list modules type "-h modules"

            -d (OPTIONAL) | use when you want to deploy app
            -n Application Name | eg -n application_portlets_war
            -p Application path on filesystem
            -cr /wps/context_root
            -prntl (OPTIONAL)## Sets classloader to Parent Last
            -prntf (OPTIONAL)## Sets classloader to Parent First

            for example: ${0} -t deploy_app -d -n application_portlets_war -p /tmp/application_portlets.war  -cr /wps/SomeApp

DEPLOY_APP
    fi
}