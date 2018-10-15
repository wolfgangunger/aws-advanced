import boto3
import logging
from datetime import datetime

running_instances_metric_name = 'NumberRunningInstances'
metric_namespace = 'EC2'

def lambda_handler(event, context):
    logging.info('Starting function...')
    ec2 = boto3.resource('ec2')
    cloudwatch = boto3.client('cloudwatch')

    timestamp = datetime.utcnow()
    logging.info(timestamp)
    num_instances = count_instances(ec2)
    logging.info('Instances: ' + str(num_instances))
    publish_metrics(cloudwatch, timestamp, num_instances)
    print "Observed %s instances running at %s" % (num_instances, timestamp)

def count_instances(ec2):
    total_instances = 0
    logging.info('Count_instances')
    instances = ec2.instances.filter(          Filters=[
              {
                  'Name': 'instance-state-name',
                  'Values': [
                      'running',
                  ]
              },
        ])
    for inst in instances:
        total_instances += 1
        print inst
    return total_instances


def publish_metrics(cloudwatch, timestamp, num_instances):
    cloudwatch.put_metric_data(
        Namespace=metric_namespace,
        MetricData=[
            {
                'MetricName': running_instances_metric_name,
                'Timestamp': timestamp,
                'Value': num_instances,
                'Unit': 'Count',
            },
            ]
        )

if __name__ == '__main__':
    lambda_handler({}, {})
