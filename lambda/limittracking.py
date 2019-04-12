import json
import boto3
import logging
import os 
from boto3.dynamodb.conditions import Key, Attr


logger = logging.getLogger()
logger.setLevel(logging.INFO)

dynamodb_client = boto3.client('dynamodb')
s3_client = boto3.client('s3')
cloudformation_client = boto3.client('cloudformation')
dynamodb_client = boto3.client('dynamodb')
dynamodb = boto3.resource('dynamodb')
sns_client = boto3.client('sns')


def lambda_handler(event, context):
 
    existing_stacks = cloudformation_client.describe_stacks()
    
    json_dumps = json.dumps(existing_stacks, indent=4, sort_keys=True, default=str)
    logger.info('Existing stacks description' + json_dumps)    
    nr_of_existing_stacks = json_dumps.count("StackId")
    nr_of_existing_stacksets = json_dumps.count("StackSetId")
    
    logger.info('Nr of existing stacks: ' + str(nr_of_existing_stacks))  
    logger.info('Nr of existing stack sets: ' + str(nr_of_existing_stacksets))  
   
    ok_status = cloudformation_data_check_dynamodb(nr_of_existing_stacks, nr_of_existing_stacksets)
          
    arn=os.environ['arn_topic']
    
    send_alarm_notification_stacks(ok_status[0], arn)
    send_alarm_notification_stackSets(ok_status[1], arn)
    logger.info('Info: ok status=1 -> limit not exceeded (alarm not raised), ok status=0 -> limit exceeded (Alarm Email sent)')    

    return 
    
def cloudformation_data_check_dynamodb(nr_of_existing_stacks, nr_of_existing_stacksets):
    
    ok_limit_stacks = 1
    ok_limit_stacksets = 1
    table = dynamodb.Table('limitTrack')
    tableData = table.scan()
    json_data = json.dumps(tableData, indent=2)
    
    logger.info('Limits of Cloudformation Service: ' + json.dumps(tableData, indent=2))
    
    tableData_Stacks = table.query(KeyConditionExpression=Key('resource').eq('stacks'))
    stackLimit = tableData_Stacks['Items'][0]['defaultLimit']
    stackLimit_int = int(stackLimit)
    logger.info('Stack limit:' + json.dumps(stackLimit_int, indent=2))
    if (stackLimit_int < nr_of_existing_stacks):
        ok_limit_stacks = 0
    logger.info('OK status for stacks:' + json.dumps(ok_limit_stacks, indent=2))
    
    tableData_StackSets = table.query(KeyConditionExpression=Key('resource').eq('stackSets'))
    stackSetLimit = tableData_StackSets['Items'][0]['defaultLimit']
    stackSetLimit_int = int(stackSetLimit)
    logger.info('Stack Sets limit:' + json.dumps(stackSetLimit_int, indent=2))
    if (stackSetLimit_int < nr_of_existing_stacksets):
        ok_limit_stacksets = 0
    logger.info('OK status for stackSets:' + json.dumps(ok_limit_stacksets, indent=2))
   
    return [ok_limit_stacks, ok_limit_stacksets]
    
def send_alarm_notification_stacks(ok_limit_stacks, arn):
    
    message = {"body": 'Take care, the limit of stack number is exceeded (200).'}
    
    if (ok_limit_stacks == 0):
        response = sns_client.publish(
        TopicArn=arn,
        Message=json.dumps({'default': json.dumps(message)}),
        MessageStructure='json')
        
    return

def send_alarm_notification_stackSets(ok_limit_stacksets, arn):
    
    message = {"body": 'Take care, the limit of stack sets is exceeded (20).'}
    
    if (ok_limit_stacksets == 0):
        response = sns_client.publish(
        TopicArn=arn,
        Message=json.dumps({'default': json.dumps(message)}),
        MessageStructure='json')
        
    return
        