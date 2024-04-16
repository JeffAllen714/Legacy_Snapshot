data "aws_lambda_function" "restore_snapshot" {
  function_name = "RestoreSnapshot"
  role          = aws_iam_role.lambda_exec_role.arn
  handler       = "index.lambda_handler"
  runtime       = "python3.9"

  filename         = "${path.module}/lambda_function.zip"
  source_code_hash = filebase64sha256("${path.module}/lambda_function.zip")

  timeout     = 300
  memory_size = 128

  environment {
    variables = {
      AWS_REGION = var.region
    }
  }
}

data "archive_file" "lambda_zip" {
  type        = "zip"
  source_file = "${path.module}/lambda_function.py"
  output_path = "${path.module}/lambda_function.zip"
}

# IAM role for the Lambda function
resource "aws_iam_role" "lambda_exec_role" {
  name               = "LambdaExecutionRole"
  assume_role_policy = data.aws_iam_policy_document.lambda_assume_role_policy.json
}

data "aws_iam_policy_document" "lambda_assume_role_policy" {
  statement {
    actions = ["sts:AssumeRole"]
    principals {
      type        = "Service"
      identifiers = ["lambda.amazonaws.com"]
    }
  }
}

# IAM policy for the Lambda function
resource "aws_iam_policy" "lambda_exec_policy" {
  name        = "LambdaExecutionPolicy"
  description = "Allows the Lambda function to create EC2 instances from snapshots"
  policy      = data.aws_iam_policy_document.lambda_exec_policy_doc.json
}

data "aws_iam_policy_document" "lambda_exec_policy_doc" {
  statement {
    actions = [
      "ec2:RunInstances",
      "ec2:DescribeImages",
      "ec2:DescribeSnapshots",
      "ec2:AllocateAddress",
      "ec2:AssociateAddress",
      "s3:GetObject"
    ]
    resources = ["*"]
  }
}

# Attach the policy to the Lambda role
resource "aws_iam_role_policy_attachment" "lambda_exec_role_policy_attachment" {
  role       = aws_iam_role.lambda_exec_role.name
  policy_arn = aws_iam_policy.lambda_exec_policy.arn
}
