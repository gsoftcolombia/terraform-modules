# ecs-scheduled-task

## Naming convention

In this Module, the unique identifier for cloud resources is `${var.name_prefix}-${var.environment}-${var.execution_name}`.

## Continuous Deployment

The responsibility of this TF module is to create majority of the infrastructure resources for the task, however the owner of the task should be the GithubAction, it is not expected that changes on the ECS Task will be performed here.

In the GithubAction you shouldn't change:

- requires_compatibilities
- network_mode
- execution_role_arn
- container_definitions.essential
- logConfiguration

Otherwise it is highly probable that your task does not run properly.

## Logging

This service use CloudWatch for logging, a new LogGroup will be created. It will also create certain custom metrics and alarms to track the behavior of the service if `var.enable_alarms` is true.

## Architectural Decisions

- Responsibility of terraform: GithubActions are responsible to define and rollout image, command, envvars and secrets.