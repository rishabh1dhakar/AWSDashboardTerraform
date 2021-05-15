#!/usr/bin/env python3
'''
Tags all AWS resources using Resource Group Tagging API
'''

import csv
import json
import logging
from os import getenv
import boto3

logger = logging.getLogger()
logger.setLevel(logging.INFO)

restricted_regions = ['cn-northwest-1', 'us-gov-east-1', 'cn-north-1', 'us-gov-west-1']
required_tags = ["Name","costCenter","Environment","createdBy","businessOwner","applicationOwner","systemOwner","operationOwner"]

organisation_account = getenv('ORG_ACCOUNT')

def get_aws_client(service_name, account_id, role = None, region = None):
  '''
  creates boto3 client
  '''

  if region is not None:
    endpoint_url = f"https://sts.{region}.amazonaws.com"
  else:
    endpoint_url = None

  if role is not None:
    sts_client = boto3.client('sts',region_name = region, endpoint_url = endpoint_url)
    role = f"arn:aws:iam::{account_id}:role/{role}"

    response = sts_client.assume_role(
            RoleArn = role,
            RoleSessionName = 'tagging_api'
        )

    session_id = response["Credentials"]["AccessKeyId"]
    session_key = response["Credentials"]["SecretAccessKey"]
    session_token = response["Credentials"]["SessionToken"]

    assumed_client = boto3.client(
      service_name = service_name,
      aws_access_key_id = session_id,
      aws_secret_access_key = session_key,
      aws_session_token = session_token,
      region_name = region
    )
  else:
      assumed_client = boto3.client(
        service_name = service_name,
        region_name = region
      )

  return assumed_client

def get_regions(account_id, role = None, region = None):
  '''
  Fetches all AWS region
  '''

  if role is not None:
    ssm = get_aws_client('ssm', account_id, role, region)
  else:
    ssm = boto3.client('ssm')

  output = list()
  for page in ssm.get_paginator('get_parameters_by_path').paginate(
    Path='/aws/service/global-infrastructure/regions'):
    output.extend(p['Value'] for p in page['Parameters'])

  return set(output) - set(restricted_regions)

def normalize_tags(tags):
  '''
  The function converts AWS type tags like {"Key" : "MyKey", "Value" : "SomeString"} to ->
  {"MyKey" : "SomeString"}
  '''

  _dict = dict()
  for tag in tags:
    _dict[tag["Key"]] = tag["Value"]

  return _dict

def get_accounts(path):
  '''
  Fetches all account IDs and roles from CSV file
  '''

  logger.info(json.dumps({'message':'Fetching account list from CSV file'}))

  output_array = list()
  csv_file = open(path)
  csv_reader = csv.DictReader(csv_file, delimiter=',')

  for row in csv_reader:
    output_array.append(row)

  return output_array

def tag_resources(account_id, role, region):
  '''
  Add missing tags to the resources
  '''

  resource_list = []

  try:
    rgt_client = get_aws_client('resourcegroupstaggingapi', account_id, role, region)
    rgt_resources = rgt_client.get_paginator('get_resources')
    count = 0

    for page in rgt_resources.paginate():
      resource_list.extend(page['ResourceTagMappingList'])

    for resource in resource_list:
      tags = normalize_tags(resource['Tags'])
      new_tags = dict()
      for required_tag in required_tags:
        if len(resource['Tags']) > 0:
          if required_tag not in tags:
            new_tags.update({required_tag: 'TBD'})
        else:
          new_tags.update({required_tag: 'TBD'})

      if len(new_tags) > 0:
        try:
          logger.info(json.dumps({'message':f"Adding tag {new_tags} to {resource['ResourceARN']}"}))
          rgt_client.tag_resources(ResourceARNList=[resource['ResourceARN']], Tags=new_tags)
          count += 1
        except Exception as err:
          logger.error(json.dumps({'message': f"unable to tag {resource['ResourceARN']}. Error message: {err}"}))
      else:
        pass

    if count == 0:
      logger.info(json.dumps({'message':f"No resources to tag in {region}"}))

  except Exception as err:
      logger.error(json.dumps({'message':f"Failed to tag resources in {region}. Error message: {err}"}))

  return True

def lambda_handler(event, context):
  '''
  Main function
  '''

  accounts = get_accounts(path=getenv('FILE_PATH'))

  for account in accounts:
    regions = None
    role = None
    account_id = account["AccountID"]
    if account_id != organisation_account:
      role = account['Role']
      try:
        logger.info(json.dumps({'message': f"Fetching regions for account {account_id}"}))
        regions = get_regions(account_id, role)
      except Exception as err:
        logger.error(json.dumps({'message':f"Unable to fetch regions for account {account_id}. Error message {err}"}))
    else:
      try:
        logger.info(json.dumps({'message': f"Fetching regions for account {account_id}"}))
        regions = get_regions(account_id)
      except Exception as err:
        logger.error(json.dumps({'message':f"Unable to fetch regions for account {account_id}. Error message {err}"}))

    if regions is not None:
      logger.info(json.dumps({'message':f"Searching for resources in account: {account_id}"}))

      for region in regions:
        tag_resources(account_id, role, region)

    logger.info(json.dumps({'message': f"finished processing for account {account_id}"}))

  return True
