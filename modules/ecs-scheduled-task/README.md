# ecs-scheduled-task

## Naming convention

In this Module, the unique identifier for cloud resources is `${var.name_prefix}-${var.environment}-${var.execution_name}`.

## Logging

This service use CloudWatch for logging, a new LogGroup will be created. It will also create certain custom metrics and alarms to track the behavior of the service if `var.enable_alarms` is true.

## Architectural Decisions

- 