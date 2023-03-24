#!/usr/bin/env bash

DEVICE_SIZE=${DEVICE_SIZE:-100g}
S3_OBJECT_SIZE=${S3_OBJECT_SIZE:-256k}
S3_PREFIX=${S3_PREFIX:-disk}

s3backer \
  --reset-mounted-flag \
  --accessFile=/tmp/.s3b_passwd \
  --baseURL="${S3_ENDPOINT_URL}" \
  --accessId="${S3_ACCESSKEY}" \
  --prefix="${S3_PREFIX}" \
  --size="${DEVICE_SIZE}" \
  --blockSize="${S3_OBJECT_SIZE}" \
  "${S3_BUCKET}"