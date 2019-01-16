#foobar = cloudtriallogs
#foo = cloudtrialbucket


resource "aws_cloudtrail" "cloudtriallogs" {
  name                          = "${var.projectName}-${var.environment}-tf-cloudtriallogs"
  s3_bucket_name                = "${aws_s3_bucket.cloudtrialbucket.id}"
  s3_key_prefix                 = "prefix"
  include_global_service_events = false
}

resource "aws_s3_bucket" "cloudtrialbucket" {
  bucket        = "${lower(var.projectName)}-${lower(var.environment)}-tf-trail"
  force_destroy = true

  policy = <<POLICY
{
    "Version": "2012-10-17",	
    "Statement": [
        {
            "Sid": "AWSCloudTrailAclCheck",
            "Effect": "Allow",
            "Principal": {
              "Service": "cloudtrail.amazonaws.com"
            },
            "Action": "s3:GetBucketAcl",
            "Resource": "arn:aws:s3:::${lower(var.projectName)}-${lower(var.environment)}-tf-trail"
        },
        {
            "Sid": "AWSCloudTrailWrite",
            "Effect": "Allow",
            "Principal": {
              "Service": "cloudtrail.amazonaws.com"
            },
            "Action": "s3:PutObject",
            "Resource": "arn:aws:s3:::${lower(var.projectName)}-${lower(var.environment)}-tf-trail/*",
            "Condition": {
                "StringEquals": {
                    "s3:x-amz-acl": "bucket-owner-full-control"
                }
            }
        }
    ]
}
POLICY
}