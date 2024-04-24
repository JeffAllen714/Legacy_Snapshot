import boto3
import time

ec2 = boto3.client('ec2')

def lambda_handler(event, context):
    try:
        snapshot_id = 'snapshot_id'  # User needs to provide the snapshot_id
        ami_id = 'ami_id'  # User needs to provide the ami_id

        # Specify the parameters for creating the new instance
        params = {
            'ImageId': ami_id,
            'InstanceType': 't2.micro',
            'MinCount': 1,
            'MaxCount': 1,
            'KeyName': 'cloudgoat-scenario-key',
            'NetworkInterfaces': [
                {
                    'DeviceIndex': 0,
                    'AssociatePublicIpAddress': True,
                    'SubnetId': 'subnet_id',  # User needs to provide the subnet ID
                    'Groups': ['security_group_id']  # User needs to provide the security group ID
                }
            ]
        }

        # Create the new EC2 instance
        response = ec2.run_instances(**params)

        # Extract the instance ID from the response
        instance_id = response['Instances'][0]['InstanceId']

        # Wait for the instance to be in the 'running' state
        print(f"Waiting for instance {instance_id} to be in 'running' state...")
        waiter = ec2.get_waiter('instance_running')
        waiter.wait(InstanceIds=[instance_id])
        print(f"Instance {instance_id} is now in 'running' state.")

        return {
            'statusCode': 200,
            'body': f'New EC2 instance created with ID: {instance_id}'
        }

    except Exception as e:
        print('Error creating new instance:', e)
        return {
            'statusCode': 500,
            'body': 'Error creating new instance'
        }
        