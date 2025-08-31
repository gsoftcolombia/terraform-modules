resource "aws_cloudwatch_log_group" "this" {
  name              = "${var.name_prefix}-${var.environment}-${var.execution_name}"
  retention_in_days = 14
}

# Metric Filter: ErrorCount
# Description: 
#   Error count during task execution.
resource "aws_cloudwatch_log_metric_filter" "ContainerErrorCount" {
  count          = var.enable_alarms ? 1 : 0
  name           = "${var.name_prefix}-${var.environment}-${var.execution_name}-ErrorCount"
  pattern        = var.alarm_error_count_pattern
  log_group_name = aws_cloudwatch_log_group.this.name

  metric_transformation {
    name      = "${var.name_prefix}-${var.environment}-${var.execution_name}-ErrorCount"
    namespace = "ECSCustom"
    value     = "1"
  }

}

# Alarm ContainerErrorCount
resource "aws_cloudwatch_metric_alarm" "ContainerErrorCount" {
  count               = var.enable_alarms ? 1 : 0
  alarm_name          = "${var.name_prefix}-${var.environment}-${var.execution_name}-ContainerErrors"
  comparison_operator = "GreaterThanOrEqualToThreshold"
  evaluation_periods  = 1
  metric_name         = "${var.name_prefix}-${var.environment}-${var.execution_name}-ErrorCount"
  namespace           = "ECSCustom"
  period              = 60
  statistic           = "Sum"
  threshold           = var.alarm_error_count_threshold
  alarm_description   = "This alarm monitors Error Count in logs during Task Execution"
  treat_missing_data  = "notBreaching"
  alarm_actions       = [aws_sns_topic.email_subscription[0].arn]
}