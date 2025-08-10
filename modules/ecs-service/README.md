# ecs-service

## Naming convention

In this Module, the unique identifier for cloud resources is `${var.name_prefix}-${var.environment}-${var.service_name}`

## Logging

This service use CloudWatch for logging, a new LogGroup will be created.

## CodeDeploy

CodeDeploy is used to deploy a new version of the ECS Service, essentially a new version is defined in the context of a new 
version of the Docker Image (code change). 

In that regards, this terraform module defines the initial setup, but it doesnt manage the new version deployments. The approach 
for new deployments includes GitHub Actions that will be executed in the moment the web application changes and a new commit is merged to main branch. 

Since there is another actor for making changes (GithubActions) there might be drifts between what you see in tf and what you see in aws. This is not a problem, this Module contains lifecycle blocks to prevent accidental changes during infrastructure changes.

## Permissions to the Container

The resource `"aws_iam_policy" "task"` contains the default policy granting some permissions to the container. The intention is not to modify or add more permissions in this policy rather than adding additional policies by using `var.container_additional_iam_policy_arn`

## Load balancing and Ports

This module creates:

- DNS Record
- ACM SSL Certificate
- LoadBalancer

The load balancer can contain two ports:

- 80 which can be enabled by using `var.expose_port_80`. This is HTTP protocol and will redirect to the HTTPS port.
- `var.service_port` which is the HTTPS port.

