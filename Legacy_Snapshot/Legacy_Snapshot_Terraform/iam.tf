# IAM user with limited permissions
resource "aws_iam_user" "ls_user" {
  name = "ls-user"
  path = "/"
}

# IAM policy to allow invoking the Lambda function
resource "aws_iam_policy" "lambda_invoke_policy" {
  name        = "LambdaInvokePolicy"
  description = "Allows invoking the Lambda function to restore EC2 instances from snapshots"

  policy = jsonencode({
    Version = "2012-10-17",
    Statement = [{
      Effect   = "Allow",
      Action   = "lambda:InvokeFunction",
      Resource = aws_lambda_function.restore_snapshot.arn
    }]
  })
}

# IAM policy to restrict restoring EC2 snapshots
resource "aws_iam_policy" "restrict_snapshot_restore_policy" {
  name        = "RestrictSnapshotRestorePolicy"
  description = "Restricts permissions to restore EC2 snapshots directly"

  policy = jsonencode({
    Version = "2012-10-17",
    Statement = [{
      Effect    = "Deny",
      Action    = "ec2:RunInstances",
      Resource  = "*",
      Condition = {
        StringEquals = {
          "ec2:SourceSnapshot": "arn:aws:ec2:*:*:snapshot/*"
        }
      }
    }]
  })
}

# Attach the Lambda invoke policy to the ls-user
resource "aws_iam_user_policy_attachment" "ls_user_lambda_invoke_policy_attachment" {
  user       = aws_iam_user.ls_user.name
  policy_arn = aws_iam_policy.lambda_invoke_policy.arn
}

# Attach the restrict snapshot restore policy to the ls-user
resource "aws_iam_user_policy_attachment" "ls_user_restrict_snapshot_restore_policy_attachment" {
  user       = aws_iam_user.ls_user.name
  policy_arn = aws_iam_policy.restrict_snapshot_restore_policy.arn
}