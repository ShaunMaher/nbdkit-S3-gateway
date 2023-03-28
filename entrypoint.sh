#!/usr/bin/env bash

DEVICE_COUNT=${DEVICE_COUNT:-3}
DEVICE_SIZE=${DEVICE_SIZE:-100g}
S3_OBJECT_SIZE=${S3_OBJECT_SIZE:-256k}
S3_PREFIX=${S3_PREFIX:-disk}
DEBUG_HTTP=${DEBUG_HTTP:-false}
TCP_PORT=${TCP_PORT:-9000}
VERBOSE="${VERBOSE}"
CONF="${CONF:-/etc/supervisor/conf.d/supervisord.conf}"

echo "${S3_ACCESSKEY}:${S3_SECRETKEY}" > /tmp/.s3b_passwd

cat supervisord_header.conf >"${CONF}"

GROUP=""
for (( i=1; i<=$DEVICE_COUNT; i++ )); do
  THIS_TCP_PORT=$(( $TCP_PORT + $i ))
  GROUP="${GROUP},disk${i}"
  cat - >>"${CONF}" <<EOF
[program:disk${i}]
autostart=true
autorestart=true
startsecs=10
stopsignal=TERM
stopwaitsecs=30 ; max num secs to wait before SIGKILL (default 10)
user=root
priority=1
stopasgroup=false
stdout_logfile=/dev/stdout
stderr_logfile=/dev/stderr
command=nbdkit s3backer --foreground --port=${THIS_TCP_PORT} ${VERBOSE} --new-style --export-name "${S3_PREFIX}${i}" baseURL="${S3_ENDPOINT_URL}" accessId="${S3_ACCESSKEY}" accessFile=/tmp/.s3b_passwd blockSize="${S3_OBJECT_SIZE}" listBlocks=true listBlocksThreads=50 ssl=true blockCacheSize=20000 blockCacheFile=/tmp/.s3b_cache blockCacheWriteDelay=15000 blockCacheThreads=4 blockCacheRecoverDirtyBlocks=true blockCacheNumProtected=1000 timeout=90 size="${DEVICE_SIZE}" debug-http=${DEBUG_HTTP} prefix="${S3_PREFIX}${i}" "${S3_BUCKET}"

EOF

done

GROUP=$(printf '%s' "${GROUP}"| sed 's/^,//g')
cat - >>"${CONF}" <<EOF
[group:disks]
programs=${GROUP}
EOF

cat "${CONF}"

exec supervisord -c "${CONF}" -n