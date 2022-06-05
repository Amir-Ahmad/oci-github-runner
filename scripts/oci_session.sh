#!/usr/bin/env bash
# Script to allow easy connections to OCI instances through bastion
# usage: oci_session.sh host port
set -euo pipefail

bastion_pubkey_path="$HOME/.ssh/private/oci_runner.pub"
bastion_privatekey_path="$HOME/.ssh/private/oci_runner"
oci_region="ap-sydney-1"
host=${1:?Usage: $0 host port}
port=${2:?Usage: $0 host port}

# Get all active sessions
sessions="$(oci bastion session list --session-lifecycle-state ACTIVE --all)"

# Check if any active session can be reused
if [ -n "${sessions}" ]; then
    session_id="$(echo "${sessions}" | 
    jq -r --arg host "${host}" \
    --arg port "${port}" \
    'first(.data[] 
    | select(."target-resource-details"."target-resource-private-ip-address"==$host)
    | select(."target-resource-details"."target-resource-port"==($port | tonumber))
    | .id)')"
fi

createSession(){
    session="$(oci bastion session create-port-forwarding \
        --key-type PUB \
        --session-ttl 10800 \
        --target-private-ip "${host}" \
        --target-port "${port}" \
        --ssh-public-key-file "${bastion_pubkey_path}" \
        --wait-for-state SUCCEEDED)"
    jq -r '.data.resources[].identifier' <<< "${session}"
}

# Create session if none is found
if [ -z "${session_id-}" ]; then
    session_id="$(createSession)"
fi

ssh -i "${bastion_privatekey_path}" "${session_id}@host.bastion.${oci_region}.oci.oraclecloud.com" -W "${host}:${port}"
