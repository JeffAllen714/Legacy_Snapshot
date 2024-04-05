import boto3

ec2 = boto3.client('ec2')

def lambda_handler(event, context):
    try:
        # Specify the parameters for creating the new instance
        params = {
            'ImageId': 'ami-0fcda13b8d17d57ac', # AMI ID for the legacy snapshot
            'InstanceType': 't2.micro', # Micro instance
            'MinCount': 1,
            'MaxCount': 1,
            'KeyName': 'Jeffrey_Allen_key_pair_RSA', # RSA key
            'SecurityGroupIds': ['sg-080f32dfe5cf01ad8'], # Security Group ID
            'SubnetId': 'subnet-1b56c67e', # Subnet ID
            'BlockDeviceMappings': [
                {
                    'DeviceName': '/dev/sda1', # root volume
                    'Ebs': {
                        'SnapshotId': 'snap-018dab12445fa9bcd' # Update snapshot ID with the correct ID
                    }
                }
            ]
            # Additional parameters as needed
        }

        # Create the new EC2 instance
        response = ec2.run_instances(**params)

        # Extract the instance ID from the response
        instance_id = response['Instances'][0]['InstanceId']

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