### CloudWatch Alarms ###
# Duration: Every time that it happens, this alarm will stay for 5-6 minutes
# Requirements: 
#   - This relay on cloudtrail module

# SNS Topic used to all Alarms
resource "aws_sns_topic" "email_subscription" {
  count = var.enable_alarms ? 1 : 0
  name  = "${var.name_prefix}-${var.environment}-${var.execution_name}-CloudWatchAlarms"
}
resource "aws_sns_topic_subscription" "email_subscription" {
  for_each  = var.enable_alarms ? toset(var.alarms_notify_to_emails) : []
  topic_arn = aws_sns_topic.email_subscription[0].arn
  protocol  = "email"
  endpoint  = each.key
}

# Alarm CannotCreateContainerErrorCount
resource "aws_cloudwatch_metric_alarm" "CannotCreateContainerErrorCount" {
  count               = var.enable_alarms ? 1 : 0
  alarm_name          = "${var.name_prefix}-${var.environment}-${var.execution_name}-CannotCreateContainer"
  comparison_operator = "GreaterThanOrEqualToThreshold"
  evaluation_periods  = 1
  metric_name         = "CannotCreateContainerErrorCount"
  namespace           = "ECSCustomCloudTrail"
  period              = 60
  statistic           = "Sum"
  threshold           = 1
  alarm_description   = "This alarm monitors that the ECS Agent can (at least) create containers defined in the TaskDefinition, if not, normally is due to a memory issue."
  treat_missing_data  = "notBreaching"
  dimensions = {
    ContainerName = "${var.name_prefix}-${var.environment}-${var.execution_name}"
  }
  alarm_actions = [aws_sns_topic.email_subscription[0].arn]
}
# Alarm OOMContainerErrorCount
resource "aws_cloudwatch_metric_alarm" "OOMContainerErrorCount" {
  count               = var.enable_alarms ? 1 : 0
  alarm_name          = "${var.name_prefix}-${var.environment}-${var.execution_name}-OOMContainer"
  comparison_operator = "GreaterThanOrEqualToThreshold"
  evaluation_periods  = 1
  metric_name         = "OOMContainerErrorCount"
  namespace           = "ECSCustomCloudTrail"
  period              = 60
  statistic           = "Sum"
  threshold           = 1
  alarm_description   = "This alarm monitors that the container has enough Memory allocated."
  treat_missing_data  = "notBreaching"
  dimensions = {
    ContainerName = "${var.name_prefix}-${var.environment}-${var.execution_name}"
  }
  alarm_actions = [aws_sns_topic.email_subscription[0].arn]
}
# Alarm CannotPullImageManifestErrorCount
resource "aws_cloudwatch_metric_alarm" "CannotPullImageManifestErrorCount" {
  count               = var.enable_alarms ? 1 : 0
  alarm_name          = "${var.name_prefix}-${var.environment}-${var.execution_name}-CannotPullImageManifest"
  comparison_operator = "GreaterThanOrEqualToThreshold"
  evaluation_periods  = 1
  metric_name         = "CannotPullImageManifestErrorCount"
  namespace           = "ECSCustomCloudTrail"
  period              = 60
  statistic           = "Sum"
  threshold           = 1
  alarm_description   = "This alarm monitors that ECS tasks are able to pull images defined in TaskDefinitions, if not, normally corresponds to a wrong image tag."
  treat_missing_data  = "notBreaching"
  dimensions = {
    ContainerName = "${var.name_prefix}-${var.environment}-${var.execution_name}"
  }
  alarm_actions = [aws_sns_topic.email_subscription[0].arn]
}

# Alarm OtherErrorCount
resource "aws_cloudwatch_metric_alarm" "OtherErrorCount" {
  count               = var.enable_alarms ? 1 : 0
  alarm_name          = "${var.name_prefix}-${var.environment}-${var.execution_name}-OtherError"
  comparison_operator = "GreaterThanOrEqualToThreshold"
  evaluation_periods  = 1
  metric_name         = "OtherErrorCount"
  namespace           = "ECSCustomCloudTrail"
  period              = 60
  statistic           = "Sum"
  threshold           = 1
  alarm_description   = "This alarm monitors that there are no other errors reported in CloudTrail."
  treat_missing_data  = "notBreaching"
  dimensions = {
    ContainerName = "${var.name_prefix}-${var.environment}-${var.execution_name}"
  }
  alarm_actions = [aws_sns_topic.email_subscription[0].arn]
}
