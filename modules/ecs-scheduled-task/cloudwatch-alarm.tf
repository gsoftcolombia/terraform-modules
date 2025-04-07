### CloudWatch Alarms ###
# Duration: Every time that it happens, this alarm will stay for 5-6 minutes
# Requirements: 
#   - This relay on cloudtrail module

# SNS Topic used to all Alarms
resource "aws_sns_topic" "email_subscription" {
  count = var.enable_alarms ? 1 : 0
  name  = "${var.name_prefix}-${var.execution_name}-CloudWatchAlarms"
}
resource "aws_sns_topic_subscription" "email_subscription" {
  count     = var.enable_alarms ? 1 : 0
  for_each  = toset(var.alarms_notify_to_emails)
  topic_arn = aws_sns_topic.email_subscription.arn
  protocol  = "email"
  endpoint  = each.key
}

# Alarm CannotPullImageManifestErrorCount
resource "aws_cloudwatch_metric_alarm" "CannotPullImageManifestErrorCount" {
  count               = var.enable_alarms ? 1 : 0
  alarm_name          = "${var.name_prefix}-${var.execution_name}-CannotPullImageManifest"
  comparison_operator = "GreaterThanOrEqualToThreshold"
  evaluation_periods  = 1
  metric_name         = "CannotPullImageManifestErrorCount"
  namespace           = "ECSCustomCloudTrail"
  period              = 60
  statistic           = "Sum"
  threshold           = 1
  alarm_description   = "This alarm monitors that ECS tasks are able to pull images defined in TaskDefinitions"
  treat_missing_data  = "notBreaching"
  dimensions = {
    ContainerName = "${var.name_prefix}-${var.execution_name}"
  }
  alarm_actions = [aws_sns_topic.email_subscription.arn]
}
