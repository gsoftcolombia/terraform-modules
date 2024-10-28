resource "aws_cloudwatch_log_group" "this" {
  name              = "${var.name_prefix}-${var.execution_name}"
  retention_in_days = 7
}