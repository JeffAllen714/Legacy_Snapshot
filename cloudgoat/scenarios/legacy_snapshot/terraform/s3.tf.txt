resource "aws_s3_bucket" "scenario_bucket" {
  bucket_prefix = "cloudgoat-scenario-"
  force_destroy = true
}

resource "aws_s3_bucket_acl" "scenario_bucket_acl" {
  bucket = aws_s3_bucket.scenario_bucket.id
  acl    = "private"
}

resource "aws_s3_object" "flag_object" {
  bucket = aws_s3_bucket.scenario_bucket.id
  key    = "assets/flag.png"
  source = "assets/flag.png"
}
