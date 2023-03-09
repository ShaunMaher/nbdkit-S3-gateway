# nbdkit-S3-gateway

## Docker Image
### Environment Variables
* `DEVICE_SIZE`: Total size of the virtual block device
* `S3_ACCESSKEY`: S3 Access Key
* `S3_BUCKET`: S3 bucket name
* `S3_ENDPOINT_URL`: S3 endpoint URL (including `https://`)
* `S3_KEY`: The block device is made up objects in the S3 storage.  All objects
  will be prefixed with this value, allowing the same bucket to be used by
  multiple virtual block devices.  This value is also used as the "export name"
  of the NBD device.
* `S3_OBJECT_SIZE`: The size of the indervidual objects in the S3 storage.
* `S3_SECRETKEY`: The secret key for accessing the bucket
* `TCP_PORT`: The TCP port that the NBD server will listen on