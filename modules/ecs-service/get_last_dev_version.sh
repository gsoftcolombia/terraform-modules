#!/bin/bash

aws_region=$1
repository_name=$2
environment_prefix=$3

image_tag=$(aws ecr describe-images --region ${aws_region} --repository-name ${repository_name} --query 'sort_by(imageDetails,& imagePushedAt)[*].imageTags[*]' | jq '.[][]' | grep ${environment_prefix} | tail -1 | tr -d '"')

echo "{ \"image_tag\": \"${image_tag}\"}"