# Legacy Snapshot Scenario

This repository contains a scenario contribution to the CloudGoat project, which is a collection of vulnerable cloud environments designed to help learn about cloud security risks and mitigation techniques.

## Scenario: Unprotected EC2 Instance Snapshots

**Background:**
A company relies on AWS for hosting its infrastructure, including an EC2 instance for their server. You will start as an IAM user with insufficient permissions but with the ability to invoke an AWS Lambda function. The Lambda function is misconfigured and allows the user to restore an EC2 instance from a snapshot that they should not have access to.


**Scenario Start:**
- Participants begin with an IAM user role (ls-user) that lacks permissions to modify or restore EC2 instance snapshots directly.


**Scenario Flow:**

1. **IAM User Reconnaissance:**
   - Participants need to perform reconnaissance as the ls-user to identify potential vulnerabilities or misconfigurations. 
   - Looking through the AWS environment will reveal that there is a snapshot of an EC2 instance that the user doesn't have permissions to restore.

2. **AWS Lambda Invocation:**
   - Identify and invoke a misconfigured AWS Lambda function that, due to excessive permissions, allows the user to restore an EC2 instance from the snapshot. 
   - The ls-user will need to update the Lambda function code with the necessary resources discovered during the reconnaissance phase

3. **Restore Snapshot:**
   - The ls-user will find that they have permissions to invoke the provided Lambda function. 
   - This Lambda function can be invoked by the ls-user, which will restore the EC2 instance from the snapshot.

4. **Accessing the Restored EC2 Instance:** 
   - After invoking the Lambda function, the ls-user can connect to the restored EC2 instance using SSH. 
   - Inside the EC2 instance, the user will find a flag image, indicating the successful completion of the scenario.

## Usage

To launch the "Legacy Snapshot" scenario, follow these steps:

1. Clone this repository or download the source code.
2. Navigate to the root directory of the CloudGoat project.
3. Run the following command to launch the scenario:
   ./cloudgoat.py create legacy_snapshot --profile <your_aws_profile>
Replace `<your_aws_profile>` with your AWS profile name.

4. The scenario infrastructure will be provisioned, including the VPC, EC2 snapshot, Lambda function, and IAM user with limited permissions.
5. Follow the scenario flow mentioned above to exploit the misconfiguration and restore the EC2 instance snapshot.

## Requirements

- Linux or macOS (Windows is not officially supported)
- Python 3.6+
- Terraform >= 0.14 installed and in your `$PATH`
- The AWS CLI installed and in your `$PATH`, and an AWS account with sufficient privileges to create and destroy resources
- `jq` (a lightweight and flexible command-line JSON processor)

## License

This project is licensed under the BSD-3 Clause.
