#!/usr/bin/env bash

create_shared_lib() {

local ISOLATED_CLASSLOADER=false

while (( $# > 0 ))
    do
    case "$1" in
    -n)
    shift
    local SHAREDLIB_NAME=${1}
    ;;
    -cp)
    shift
    while [[ $# > 0 ]]; do
        local SHAREDLIB_CLASSPATH+="${1} "
        if [[ ${2} =~ ^"-" ]]; then
            debugmode echo MINUS DETECTED ${2}
            break
        fi
        shift
    done
    ;;
    -np)
    shift
    while [[ $# > 0 ]]; do
        local SHAREDLIB_NATIVE_CLASSPATH+="${1} "
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
        local SHAREDLIB_DESCRIPTION+="${1} "
        if [[ ${2} =~ ^"-" ]]; then
            debugmode echo MINUS DETECTED ${2}
            break
        fi
        shift
    done
    ;;
    -i)
    local ISOLATED_CLASSLOADER=true
    ;;
    *)
    echo "Unknown argument for create_shared_lib: $1"
    exit 1
    ;;
    esac
    shift
done

    #Variable Magic

    local SHAREDLIB_DESCRIPTION=${SHAREDLIB_DESCRIPTION%?}
    local SHAREDLIB_CLASSPATH=${SHAREDLIB_CLASSPATH%?}
    local SHAREDLIB_NATIVE_CLASSPATH=${SHAREDLIB_NATIVE_CLASSPATH%?}

    run_command "AdminConfig.create('Library', AdminConfig.getid('${SHAREDLIB_SCOPE}/'), '[[nativePath \\\"${SHAREDLIB_NATIVE_CLASSPATH}\\\"] [name \\\"${SHAREDLIB_NAME}\\\"] [isolatedClassLoader \\\"${ISOLATED_CLASSLOADER}\\\" ] [description \\\"${SHAREDLIB_DESCRIPTION}\\\" ] [classPath \\\"${SHAREDLIB_CLASSPATH}\\\" ]]')"

    save_config

    exit 0

}