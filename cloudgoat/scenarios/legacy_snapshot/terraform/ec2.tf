resource "aws_key_pair" "ec2_key_pair" {
  key_name   = "cloudgoat-scenario-key"
  public_key = tls_private_key.ssh_key.public_key_openssh
}

resource "tls_private_key" "ssh_key" {
  algorithm = "RSA"
  rsa_bits  = 4096
}

resource "aws_s3_object" "ssh_key_object" {
  bucket  = aws_s3_bucket.scenario_bucket.id
  key     = "ssh_key"
  content = tls_private_key.ssh_key.private_key_pem
}

resource "aws_security_group" "ec2_security_group" {
  name_prefix = "cloudgoat-ec2-"
  vpc_id      = aws_vpc.cg_vpc.id

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_ebs_volume" "flag_volume" {
  availability_zone = aws_subnet.cg_public_subnet_1.availability_zone
  size              = 10
  tags = {
    Name = "CloudGoat Flag Volume"
  }
}

resource "aws_ebs_snapshot" "flag_snapshot" {
  volume_id   = aws_ebs_volume.flag_volume.id
  description = "Snapshot containing the flag"
  tags = {
    Name = "CloudGoat Flag Snapshot"
  }
}
