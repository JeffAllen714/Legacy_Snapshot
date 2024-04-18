# iam.tf
resource "aws_iam_user" "ls_user" {
  name = "ls-user"
  path = "/"
}

resource "aws_iam_policy" "lambda_invoke_policy" {
  name        = "LambdaInvokePolicy"
  description = "Allows invoking the Lambda function to restore EC2 instances from snapshots"

  policy = jsonencode({
    Version = "2012-10-17",
    Statement = [{
      Effect   = "Allow"
      Action   = "lambda:InvokeFunction"
      Resource = aws_lambda_function.restore_snapshot.arn
    }]
  })
}

resource "aws_iam_policy" "restrict_snapshot_restore_policy" {
  name        = "RestrictSnapshotRestorePolicy"
  description = "Restricts permissions to restore EC2 snapshots directly"

  policy = jsonencode({
    Version = "2012-10-17",
    Statement = [{
      Effect    = "Deny"
      Action    = "ec2:RestoreSnapshot"
      Resource  = "*"
    }]
  })
}

resource "aws_iam_user_policy_attachment" "ls_user_lambda_invoke_policy_attachment" {
  user       = aws_iam_user.ls_user.name
  policy_arn = aws_iam_policy.lambda_invoke_policy.arn
}

resource "aws_iam_user_policy_attachment" "ls_user_restrict_snapshot_restore_policy_attachment" {
  user       = aws_iam_user.ls_user.name
  policy_arn = aws_iam_policy.restrict_snapshot_restore_policy.arn
}

resource "aws_iam_policy" "s3_read_policy" {
  name        = "S3ReadPolicy"
  description = "Allows read access to the scenario S3 bucket"

  policy = jsonencode({
    Version = "2012-10-17",
    Statement = [{
      Effect   = "Allow"
      Action   = "s3:GetObject"
      Resource = "${aws_s3_bucket.scenario_bucket.arn}/*"
    }]
  })
}

resource "aws_iam_user_policy_attachment" "ls_user_s3_read_policy_attachment" {
  user       = aws_iam_user.ls_user.name
  policy_arn = aws_iam_policy.s3_read_policy.arn
}

resource "aws_iam_policy" "lambda_update_policy" {
  name        = "LambdaUpdatePolicy"
  description = "Allows updating the Lambda function code"

  policy = jsonencode({
    Version = "2012-10-17",
    Statement = [{
      Effect = "Allow"
      Action = [
        "lambda:UpdateFunctionCode",
        "lambda:GetFunction"
      ]
      Resource = aws_lambda_function.restore_snapshot.arn
    }]
  })
}

resource "aws_iam_user_policy_attachment" "ls_user_lambda_update_policy_attachment" {
  user       = aws_iam_user.ls_user.name
  policy_arn = aws_iam_policy.lambda_update_policy.arn
}
