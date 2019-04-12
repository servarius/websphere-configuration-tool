#!/usr/bin/env bash

menu() {
      SOAP_PORT=none
      SOAP_HOSTNAME=none
    while (( $# > 0 ))
            do
            case "$1" in
            -h | --help)
            shift
            show_help ${1}
            exit 0
            ;;
            -s | --scope)
            shift
            set_scope ${1}
            ;;
            -Cl | --ClusterName)
            shift
            CLUSTER_NAME=${1}
            ;;
            -C | --CellName)
            shift
            CELL_NAME=${1}
            ;;
            -N | --NodeName)
            shift
            NODE_NAME=${1}
            ;;
            -S | --ServerName)
            shift
            SERVER_NAME=${1}
            ;;
            -host)
            shift
            SOAP_HOSTNAME=${1}
            ;;
            -port)
            shift
            SOAP_PORT=${1}
            ;;
            -user)
            shift
            SOAP_USERNAME=${1}
            ;;
            -password)
            shift
            SOAP_PASSWORD=${1}
            ;;
            -t | --taskname)
            shift
            while [[ $# > 0 ]]; do
                TASK_ARGS+="${1} "
                shift
            done
            run_task ${TASK_ARGS}
            ;;
            --DEBUG)
            DEBUG_MODE="1"
            ;;
            *)
            echo "Unknown argument in menu: $1"
            exit 1
            ;;
            esac
            shift
    done
}