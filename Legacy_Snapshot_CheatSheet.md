
Reconnaissance:
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

Identify Lambda Function Permissions:
```
# Get the policy document for the Lambda invoke policy
aws iam get-policy-version --policy-arn <lambda_invoke_policy_arn> --version-id <version>
```

Invoke the Lambda Function:
```
# Invoke the Lambda function and save the output to a file
aws lambda invoke --function-name RestoreSnapshot output.txt

# View the output from the Lambda function (should contain the new instance ID)
cat output.txt
```

