#!/bin/bash

DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null && pwd )"
cd $DIR
cd ..

source ~/.enthought_demo_environment

md5sig="`ssh-keygen -E md5 -lf ${demo_admin_key} | awk '{print $2}' | sed -e 's/md5://g'`"
terraform refresh \
  -var "aws_access_key=${AWS_DEMO_KEY}" \
  -var "aws_secret_key=${AWS_DEMO_SECRET}" \
  -var "pub_key=${demo_admin_key}" \
  -var "pvt_key=${demo_admin_key}" \
  -var "rds_username=$rds_username" \
  -var "rds_password=$rds_password" \
  -var "hosted_zone_id=$hosted_zone_id" \
  -var "ssh_fingerprint=$SSH_FINGERPRINT"
