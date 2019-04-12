import boto3
import json
from botocore.vendored import requests
import logging
import os
import sys
import base64


logger = logging.getLogger()
logger.setLevel(logging.INFO)

s3_client = boto3.client('s3')
s3 = boto3.resource('s3')

codecommit = boto3.client('codecommit')

def lambda_handler(event, context):
    
# # # # # # # # # # # # # # #code-commit get repo url and commit information
# # # # # # # # # # # # # # #I would need permissions to this Role | a new Role with needed permissions
    # references = { reference['ref'] for reference in event['Records'][0]['codecommit']['references'] }
    # print("References: "  + str(references))
    
    # repository = event['Records'][0]['eventSourceARN'].split(':')[5]
    
    # commitId = event['Records'][0]['codecommit']['references'][0]['commit']
    # print("CommitId: "  + commitId)
    # try:
    #     response = codecommit.get_repository(repositoryName=repository)
    #     print("Repo: " + response['repositoryMetadata']['cloneUrlHttp'])
    #     return response['repositoryMetadata']['cloneUrlHttp']
    # except Exception as e:
    #     print(e)
    #     print('Error getting the repo.'.format(repository))
    #     raise e
# # # # # # # # # # # # # # #code-commit get repo url and commit information
    
# # # # # # # # # # # # # # #get all the information from repo
    # differences = codecommit.get_differences(repositoryName=repository, afterCommitSpecifier=commitId)
    # blobId =differences['differences'][0]['afterBlob']['blobId']
    # content = codecommit.get_blob(repositoryName=repository, blobId=blobId)
    # new_resource = base64.b64decode(content).decode('utf-8')
    # new_resource_json = json.dumps(new_user)
# # # # # # # # # # # # # # #get all the information from repo

# # # # # # # # # # # # # # #update the template stored on s3 with new resources
    # bucket=os.environ['bucket']
    # template=os.environ['templateName']
    # new_resource_json=os.environ['templateName2']

    # update_template(bucket, template, new_resource_json)
# # # # # # # # # # # # # # #update the template stored on s3 with new resources    
     return
    

def update_template(bucket, templateName, templateName2):
    
    
        template = s3.Object(bucket, templateName).get()['Body'].read().decode('utf-8')
        template2 = s3.Object(bucket, templateName2).get()['Body'].read().decode('utf-8')
        json_content_template = json.loads(template)
        json_content_new_resource = json.loads(template2)
        
        merged = {key: value for (key, value) in (json_content_template.items() + json_content_new_resource.items())}

        file = json.dumps(merged)
        print(file)
        response = s3_client.put_object(Bucket=bucket, Body= file, Key='resultsmerge.json')
	
        return response
    
    
    
# # # # # # # # # # # # # # # code to try clone the Repo from CodeCommit and upload to S3    
    #cloning(bucket)
    #bucket = os.environ['bucket']
    #s3.Bucket(bucket).download_file(filename, '/tmp/error.html')
    #s3.meta.client.upload_file('/tmp/index.html', bucket, 'index.html')
    #print(os.path.isdir("/tmp/nagyma"))
    #s3_client.download_file(bucket, filename, '/tmp/'+filename)
# # # # # # # # # # # # # # # code to try clone the Repo from CodeCommit and upload to S3   
    
def cloning(bucket):

        path        =   "/tmp" 
        clone       =   "git clone" 
        
       
        os.chdir(path) 
        os.system(clone) 
        
        for root, dirs, files in os.walk(".", topdown=False):
            for name in files:
                print(os.path.join(root, name))
            for name in dirs:
                print(os.path.join(root, name))
            
