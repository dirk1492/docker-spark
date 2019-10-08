#!/bin/bash

set -o errexit
set -o nounset
set -o pipefail
#set -o xtrace
# shellcheck disable=SC1091

# Load libraries
. /libspark.sh
. /libos.sh

# Load Spark environment variables
eval "$(spark_env)"

if [ ! -z "$SPARK_KUBE_SERVICE" ]; then
    if [ "$SPARK_KUBE_SERVICE" == "hostname" ]; then
        HOSTNAME=$(hostname)
        PUBLIC_ADDR=$(/usr/bin/kube-external-ip --selector statefulset.kubernetes.io/pod-name=$HOSTNAME)
        if [ ! -z "$PUBLIC_ADDR" ]; then
            export SPARK_PUBLIC_DNS="$PUBLIC_ADDR"
            info "Public address detected: SPARK_PUBLIC_DNS=$SPARK_PUBLIC_DNS"         
        fi
    else    
        PUBLIC_ADDR=$(/usr/bin/kube-external-ip --selector $SPARK_KUBE_SERVICE)
        if [ ! -z "$PUBLIC_ADDR" ]; then
            export SPARK_PUBLIC_DNS="$PUBLIC_ADDR"
            info "Public address detected: SPARK_PUBLIC_DNS=$SPARK_PUBLIC_DNS"         
        fi
    fi
fi    

if [ -z "$SPARK_WORKER_WEBUI_PORT" ]; then
    if [ $SPARK_MODE == "worker" ]; then
        ID=$(hostname | awk -F- '{ print $NF }' | grep "^[0-9]*$" || true)
        if [ ! -z "$ID" ]; then
            info "Spark worker no: $ID"
            export SPARK_WORKER_WEBUI_PORT=$(expr 5050 + $ID)
            info "Set SPARK_WORKER_WEBUI_PORT = $SPARK_WORKER_WEBUI_PORT"
        fi
    fi
fi

if [ "$SPARK_MODE" == "master" ]; then
    # Master constants
    EXEC=$(command -v start-master.sh)
    ARGS=()
    info "** Starting Spark in master mode **"
elif [ "$SPARK_MODE" == "thriftserver" ]; then
    # Master constants
    EXEC=$(command -v start-thriftserver.sh)
    ARGS=("--master=$SPARK_MASTER_URL")
    info "** Starting Spark Thriftserver **"
else
    # Worker constants
    EXEC=$(command -v start-slave.sh)
    ARGS=("$SPARK_MASTER_URL")
    info "** Starting Spark in worker mode **"
fi

if am_i_root; then
    exec gosu "$SPARK_DAEMON_USER" "$EXEC" "${ARGS[@]}"
else
    exec "$EXEC" "${ARGS[@]}"
fi
