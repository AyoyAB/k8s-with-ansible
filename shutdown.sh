#!/usr/bin/env bash
# RedHat recommendation is 10 minuter for large clusters with 10 nodes or more.
# Therefore, for production clusters, set SECONDS_AFTER_NODES to 600.
# https://docs.openshift.com/container-platform/4.8/backup_and_restore/graceful-cluster-shutdown.html
MINUTES_TO_SHUTDOWN=${MINUTES_TO_SHUTDOWN:-0}
SECONDS_AFTER_NODES=${SECONDS_AFTER_NODES:-120}

SCRIPT_DIR="$( cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )"

ansible -i "${SCRIPT_DIR}/inventories/example/hosts" nodes -m raw -a "/usr/sbin/shutdown ${MINUTES_TO_SHUTDOWN}" --become
echo "Wait ${SECONDS_AFTER_NODES} seconds for nodes to shutdown first."
sleep "${SECONDS_AFTER_NODES}"
ansible -i "${SCRIPT_DIR}/inventories/example/hosts" masters -m raw -a "/usr/sbin/shutdown 1" --become
