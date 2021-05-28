#!/bin/bash

scs_shared_route53_arn=$1
scs_aws_route53_private_zone_id=$2
scs_shared_vpc_id=$3

CREDENTIALS=`aws sts assume-role --role-arn ${scs_shared_route53_arn} --role-session-name RoleSession --duration-seconds 900 --output=json` ;
export AWS_DEFAULT_REGION=ca-central-1;
export AWS_ACCESS_KEY_ID=`echo ${CREDENTIALS} | jq -r '.Credentials.AccessKeyId'` ;
export AWS_SECRET_ACCESS_KEY=`echo ${CREDENTIALS} | jq -r '.Credentials.SecretAccessKey'`;
export AWS_SESSION_TOKEN=`echo ${CREDENTIALS} | jq -r '.Credentials.SessionToken'`;
export AWS_EXPIRATION=`echo ${CREDENTIALS} | jq -r '.Credentials.Expiration'` ;


aws route53 associate-vpc-with-hosted-zone \
  --hosted-zone-id ${scs_aws_route53_private_zone_id} \
  --vpc VPCRegion=ca-central-1,VPCId=${scs_shared_vpc_id} \
  &>/dev/null

echo {}