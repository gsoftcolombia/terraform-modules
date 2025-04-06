# Metric Filter: CannotCreateContainerErrorCount
# Description: 
#   This usually happens when the container can't even start, it will require at least 6MB of Memory
#   This is not an OOM since the container couldn't even start.
resource "aws_cloudwatch_log_metric_filter" "CannotCreateContainerErrorCount" {
  name           = "CannotCreateContainerErrorCount"
  pattern        = "{ $.requestParameters.containers[0].reason=\"CannotCreateContainerError*\" }"
  log_group_name = aws_cloudwatch_log_group.cloudtrail_monitoring.name

  metric_transformation {
    name      = "CannotCreateContainerErrorCount"
    namespace = "ECSCustomCloudTrail"
    value     = "1"

    dimensions = {
      ContainerName = "$.requestParameters.containers[0].containerName"
    }
  }
}

# Metric Filter: OOMContainerErrorCount
# Description:
#   The container failed due to Out of Memory
resource "aws_cloudwatch_log_metric_filter" "OOMContainerErrorCount" {
  name           = "OOMContainerErrorCount"
  pattern        = "{ $.requestParameters.containers[0].exitCode=137 }"
  log_group_name = aws_cloudwatch_log_group.cloudtrail_monitoring.name

  metric_transformation {
    name      = "OOMContainerErrorCount"
    namespace = "ECSCustomCloudTrail"
    value     = "1"

    dimensions = {
      ContainerName = "$.requestParameters.containers[0].containerName"
    }
  }
}

# Metric Filter: CannotPullImageManifestErrorCount
# Description:
#   For some reason, the ECS Agent couldn't pull the image defined in the TaskDefinition
#   Maybe the image doesn't exists anymore or there are no permissions to do it.
resource "aws_cloudwatch_log_metric_filter" "CannotPullImageManifestErrorCount" {
  name           = "CannotPullImageManifestErrorCount"
  pattern        = "{ $.requestParameters.containers[0].reason=\"CannotPullImageManifestError*\" }"
  log_group_name = aws_cloudwatch_log_group.cloudtrail_monitoring.name

  metric_transformation {
    name      = "CannotPullImageManifestErrorCount"
    namespace = "ECSCustomCloudTrail"
    value     = "1"

    dimensions = {
      ContainerName = "$.requestParameters.containers[0].containerName"
    }
  }
}

# Metric Filter: OtherErrorCount
# Description:
#   Count of other errors not defined in these Metric Filters.
resource "aws_cloudwatch_log_metric_filter" "OtherErrorCount" {
  name           = "OtherErrorCount"
  pattern        = "{ ($.requestParameters.containers[0].reason=\"*Error*\") && ($.requestParameters.containers[0].reason!=\"CannotPullImageManifestError*\") && ($.requestParameters.containers[0].reason!=\"CannotCreateContainerError*\") && ($.requestParameters.containers[0].reason!=\"OutOfMemoryError*\") }"
  log_group_name = aws_cloudwatch_log_group.cloudtrail_monitoring.name

  metric_transformation {
    name      = "OtherErrorCount"
    namespace = "ECSCustomCloudTrail"
    value     = "1"

    dimensions = {
      ContainerName = "$.requestParameters.containers[0].containerName"
    }
  }
}