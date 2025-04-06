resource "aws_cloudtrail" "trail_monitoring" {
  depends_on                    = [aws_s3_bucket_policy.trail_monitoring]
  name                          = "${var.name_prefix}-trail-monitoring"
  s3_bucket_name                = aws_s3_bucket.trail_monitoring.id
  include_global_service_events = false
  cloud_watch_logs_group_arn    = "${aws_cloudwatch_log_group.cloudtrail_monitoring.arn}:*"
  cloud_watch_logs_role_arn     = aws_iam_role.cloud_trail_monitoring.arn
}

resource "aws_s3_bucket" "trail_monitoring" {
  bucket        = "${var.name_prefix}-trail-monitoring"
  force_destroy = true
}

data "aws_iam_policy_document" "s3_trail_monitoring" {
  statement {
    sid    = "AWSCloudTrailAclCheck"
    effect = "Allow"

    principals {
      type        = "Service"
      identifiers = ["cloudtrail.amazonaws.com"]
    }

    actions   = ["s3:GetBucketAcl"]
    resources = [aws_s3_bucket.trail_monitoring.arn]
    condition {
      test     = "StringEquals"
      variable = "aws:SourceArn"
      values   = ["arn:${data.aws_partition.current.partition}:cloudtrail:${data.aws_region.current.name}:${data.aws_caller_identity.current.account_id}:trail/${var.name_prefix}-trail-monitoring"]
    }
  }

  statement {
    sid    = "AWSCloudTrailWrite"
    effect = "Allow"

    principals {
      type        = "Service"
      identifiers = ["cloudtrail.amazonaws.com"]
    }

    actions   = ["s3:PutObject"]
    resources = ["${aws_s3_bucket.trail_monitoring.arn}/AWSLogs/${data.aws_caller_identity.current.account_id}/*"]

    condition {
      test     = "StringEquals"
      variable = "s3:x-amz-acl"
      values   = ["bucket-owner-full-control"]
    }
    condition {
      test     = "StringEquals"
      variable = "aws:SourceArn"
      values   = ["arn:${data.aws_partition.current.partition}:cloudtrail:${data.aws_region.current.name}:${data.aws_caller_identity.current.account_id}:trail/${var.name_prefix}-trail-monitoring"]
    }
  }
}

resource "aws_s3_bucket_policy" "trail_monitoring" {
  bucket = aws_s3_bucket.trail_monitoring.id
  policy = data.aws_iam_policy_document.s3_trail_monitoring.json
}

resource "aws_cloudwatch_log_group" "cloudtrail_monitoring" {
  name              = "${var.name_prefix}-trail-monitoring"
  retention_in_days = 14
}

resource "aws_iam_role_policy" "cloud_trail_monitoring" {
  name = "${var.name_prefix}-trail-monitoring"
  role = aws_iam_role.cloud_trail_monitoring.id

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        "Sid" : "AWSCloudTrailCreateLogStream",
        "Effect" : "Allow",
        "Action" : [
          "logs:CreateLogStream"
        ],
        "Resource" : [
          "arn:aws:logs:${data.aws_region.current.name}:${data.aws_caller_identity.current.account_id}:log-group:${var.name_prefix}-trail-monitoring:log-stream:*"
        ]

      },
      {
        "Sid" : "AWSCloudTrailPutLogEvents",
        "Effect" : "Allow",
        "Action" : [
          "logs:PutLogEvents"
        ],
        "Resource" : [
          "arn:aws:logs:${data.aws_region.current.name}:${data.aws_caller_identity.current.account_id}:log-group:${var.name_prefix}-trail-monitoring:log-stream:*"
        ]
      }
    ]
  })
}

resource "aws_iam_role" "cloud_trail_monitoring" {
  name = "${var.name_prefix}-trail-monitoring"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Sid    = ""
        Principal = {
          Service = "cloudtrail.amazonaws.com"
        }
      },
    ]
  })

}
