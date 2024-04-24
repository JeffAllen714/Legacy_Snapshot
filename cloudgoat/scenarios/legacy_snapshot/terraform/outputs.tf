# outputs.tf

output "ls_user_access_key_id" {
  value = aws_iam_access_key.ls_user_access_key.id
}

output "ls_user_secret_access_key" {
  value     = aws_iam_access_key.ls_user_access_key.secret
  sensitive = true
}
