#!/usr/bin/env bash

get_id() {

    local OBJECT_NAME=${@}

    run_command "AdminConfig.getid( '${OBJECT_NAME}')"
}