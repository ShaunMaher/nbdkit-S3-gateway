#!/usr/bin/env bash

nbdkit S3 \
  --foreground \
  --port=${TCP_PORT:-9001} \
  --verbose \
  --new-style \
  --export-name "${S3_KEY}" \
  access-key="${S3_ACCESSKEY}" \
  bucket="${S3_BUCKET}" \
  endpoint-url="${S3_ENDPOINT_URL}" \
  key="${S3_KEY}" \
  object-size="${S3_OBJECT_SIZE}" \
  secret-key="${S3_SECRETKEY}" \
  size="${DEVICE_SIZE}"

sleep 3600