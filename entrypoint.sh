#!/usr/bin/env bash

DEVICE_SIZE=${DEVICE_SIZE:-100g}
S3_OBJECT_SIZE=${S3_OBJECT_SIZE:-256k}
S3_PREFIX=${S3_PREFIX:-disk}
DEBUG_HTTP=${DEBUG_HTTP:-false}

# nbdkit S3 \
#   --foreground \
#   --port=${TCP_PORT:-9001} \
#   --verbose \
#   --new-style \
#   --export-name "${S3_PREFIX}" \
#   access-key="${S3_ACCESSKEY}" \
#   bucket="${S3_BUCKET}" \
#   endpoint-url="${S3_ENDPOINT_URL}" \
#   key="${S3_PREFIX}" \
#   object-size="${S3_OBJECT_SIZE}" \
#   secret-key="${S3_SECRETKEY}" \
#   size="${DEVICE_SIZE}"

echo "${S3_ACCESSKEY}:${S3_SECRETKEY}" > /tmp/.s3b_passwd

nbdkit s3backer \
  --foreground \
  --port=${TCP_PORT:-9001} \
  --verbose \
  --new-style \
  --export-name "${S3_PREFIX}" \
  baseURL="${S3_ENDPOINT_URL}" \
  accessId="${S3_ACCESSKEY}" \
  accessFile=/tmp/.s3b_passwd \
  blockSize="${S3_OBJECT_SIZE}" \
  listBlocks=true \
  listBlocksThreads=50 \
  ssl=true \
  blockCacheSize=20000 \
  blockCacheFile=/tmp/.s3b_cache \
  blockCacheWriteDelay=15000 \
  blockCacheThreads=4 \
  blockCacheRecoverDirtyBlocks=true \
  blockCacheNumProtected=1000 \
  timeout=90 \
  size="${DEVICE_SIZE}" \
  debug-http=${DEBUG_HTTP} \
  prefix="${S3_PREFIX}" \
  force=true \
  "${S3_BUCKET}"

#s3backer \
#  --nbd \
#  --size="${DEVICE_SIZE}" \
#  --blockSize=${S3_OBJECT_SIZE} \
#  --listBlocks \
#  --listBlocksThreads=50


sleep 3600