# nbdkit-S3-gateway
This project aims to use nbdkit's ability to present a block device backed by
objects in an S3 bucket as a service an NBD Client can connect to.

The NBD Client will then present a block device that will have a ZFS zpool
created on it, which will in turn be used as a target for backups of live ZFS
datasets (`zfs send` `zfs recv`).

The goal is thin incremental ZFS dataset backups to cheap offsite cloud storage.

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