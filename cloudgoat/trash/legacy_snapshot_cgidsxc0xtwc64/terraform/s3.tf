resource "aws_s3_bucket" "scenario_bucket" {
  bucket_prefix = "cloudgoat-scenario-"
  force_destroy = true
  acl           = "private"
}
