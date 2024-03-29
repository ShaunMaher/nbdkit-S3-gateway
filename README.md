# nbdkit-S3-gateway
This project aims to use nbdkit's ability to present a block device backed by
objects in an S3 bucket as a service an NBD Client can connect to.

The NBD Client will then present a block device that will have a ZFS zpool
created on it, which will in turn be used as a target for backups of live ZFS
datasets (`zfs send` `zfs recv`).

The goal is thin incremental ZFS dataset backups to cheap offsite cloud storage.

## Experiment 1 - nbdkit and the included S3 plugin
This worked but seemed very slow.

## Experiment 2 - nbdkit and s3backer plugin

## Docker Image
### Environment Variables
* `DEVICE_SIZE`: Total size of the virtual block device
* `DEBUG_HTTP`: Ask s3backer to write all it's HTTP request and response headers
  to the log.
* `S3_ACCESSKEY`: S3 Access Key
* `S3_BUCKET`: S3 bucket name
* `S3_ENDPOINT_URL`: S3 endpoint URL (including `https://`)
* `S3_PREFIX`: The block device is made up objects in the S3 storage.
  All objects will be prefixed with this value, allowing the same bucket to be
  used by multiple virtual block devices.  This value is also used as the
  "export name" of the NBD device.
* `S3_OBJECT_SIZE`: The size of the indervidual objects in the S3 storage.
* `S3_SECRETKEY`: The secret key for accessing the bucket
* `TCP_PORT`: The TCP port that the NBD server will listen on

## Suitable Wasabi Policy
This might be overkill but it works.  Trimming it down will be a future
experiment.
```json
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Sid": "AddCannedAcl",
      "Effect": "Allow",
      "Principal": {
        "AWS": "arn:aws:iam::100000190796:user/ph3.local"
      },
      "Action": [
        "s3:GetObject",
        "s3:GetObjectAcl",
        "s3:ListBucket",
        "s3:PutObject",
        "s3:PutObjectAcl",
        "s3:DeleteObject"
      ],
      "Resource": "arn:aws:s3:::syncoid-ph3-local/*"
    },
    {
      "Sid": "AddCannedAcl",
      "Effect": "Allow",
      "Principal": {
        "AWS": "arn:aws:iam::100000190796:user/ph3.local"
      },
      "Action": [
        "s3:GetObject",
        "s3:GetObjectAcl",
        "s3:ListBucket",
        "s3:PutObject",
        "s3:PutObjectAcl",
        "s3:DeleteObject"
      ],
      "Resource": "arn:aws:s3:::syncoid-ph3-local"
    }
  ]
}
```