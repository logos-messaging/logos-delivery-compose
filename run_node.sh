#!/bin/sh

echo "I am a nwaku mix node (testnet-0.2)"

MY_EXT_IP="${MY_EXT_IP:-$(wget -qO- https://api4.ipify.org)}"

# NODEKEY env -> --nodekey flag for stable peer ID
if [ -n "${NODEKEY}" ]; then
    NODEKEY_FLAG="--nodekey=${NODEKEY}"
fi

# KAD_BOOTSTRAP_NODES env (comma-separated multiaddrs) -> repeated --kad-bootstrap-node flags
# Each entry must be /dns4/<host>/tcp/<port>/p2p/<peerID> (peerID required by libp2p).
KAD_BOOTSTRAP_FLAGS=""
if [ -n "${KAD_BOOTSTRAP_NODES}" ]; then
    KAD_BOOTSTRAP_FLAGS=$(echo "${KAD_BOOTSTRAP_NODES}" | tr ',' '\n' | sed 's/^/--kad-bootstrap-node=/' | tr '\n' ' ')
fi

exec /usr/bin/wakunode\
    --mix=true\
    --mix-disable-cover-traffic=${MIX_DISABLE_COVER_TRAFFIC:-true}\
    --enable-kad-discovery=true\
    --relay=true\
    --filter=true\
    --lightpush=true\
    --cluster-id=${CLUSTER_ID:-2}\
    --num-shards-in-network=${NUM_SHARDS_IN_NETWORK:-1}\
    --shard=${SHARD:-0}\
    --keep-alive=true\
    --max-connections=${MAX_CONNECTIONS:-150}\
    --log-level=${LOG_LEVEL:-INFO}\
    --tcp-port=${TCP_PORT:-30304}\
    --nat=extip:"${MY_EXT_IP}"\
    --metrics-server=true\
    --metrics-server-port=${METRICS_PORT:-8003}\
    --metrics-server-address=0.0.0.0\
    ${NODEKEY_FLAG}\
    ${KAD_BOOTSTRAP_FLAGS}\
    ${EXTRA_ARGS}
