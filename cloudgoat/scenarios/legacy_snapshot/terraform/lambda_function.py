import boto3

ec2 = boto3.client('ec2')
s3 = boto3.client('s3')

def lambda_handler(event, context):
    try:
        snapshot_id = event['snapshot_id']  # Get the snapshot ID from the event payload

        # Specify the parameters for creating the new instance
        params = {
            'ImageId': 'ami-0fcda13b8d17d57ac',
            'InstanceType': 't2.micro',
            'MinCount': 1,
            'MaxCount': 1,
            'KeyName': aws_key_pair.ec2_key_pair.key_name,
            'SecurityGroupIds': [aws_security_group.ec2_security_group.id],
            'SubnetId': aws_subnet.cg_public_subnet_1.id,
            'BlockDeviceMappings': [
                {
                    'DeviceName': '/dev/sda1',
                    'Ebs': {
                        'SnapshotId': snapshot_id  # Use the provided snapshot ID
                    }
                }
            ]
        }

        # Create the new EC2 instance
        response = ec2.run_instances(**params)

        # Extract the instance ID from the response
        instance_id = response['Instances'][0]['InstanceId']
        
        # Allocate and associate an Elastic IP
        eip_allocation = ec2.allocate_address(Domain='vpc')
        ec2.associate_address(InstanceId=instance_id, AllocationId=eip_allocation['AllocationId'])
        
        # Download flag.png from S3 and place it on the desktop
        s3.download_file(aws_s3_bucket.scenario_bucket.id, 'assets/flag.png', '/home/ec2-user/Desktop/flag.png')

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
