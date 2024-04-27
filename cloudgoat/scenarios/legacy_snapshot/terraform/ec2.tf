# ec2.tf

# Create the SSH key pair
resource "tls_private_key" "ssh_key" {
  algorithm = "RSA"
  rsa_bits  = 4096
}

resource "aws_key_pair" "ec2_key_pair" {
  key_name   = "cloudgoat-scenario-key"
  public_key = tls_private_key.ssh_key.public_key_openssh
}

# Create the security group
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

# Create the EBS volume
resource "aws_ebs_volume" "flag_volume" {
  availability_zone = aws_subnet.cg_public_subnet_1.availability_zone
  size              = 8  # Adjusted to match the working AMI
  type              = "gp3"  # Adjusted to match the working AMI

  tags = {
    Name = "CloudGoat Flag Volume"
  }
}

# Create the EBS snapshot
resource "aws_ebs_snapshot" "flag_snapshot" {
  volume_id   = aws_ebs_volume.flag_volume.id
  description = "Snapshot containing the flag"
  tags = {
    Name = "CloudGoat Flag Snapshot"
  }
  lifecycle {
    # prevent_destroy = true
  }
}

# Create the AMI
resource "aws_ami" "flag_ami" {
  name                = "CloudGoat Flag AMI"
  virtualization_type = "hvm"
  root_device_name    = "/dev/sda1"
  ena_support         = true  # Enable ENA support

  ebs_block_device {
    device_name = "/dev/sda1"
    snapshot_id = aws_ebs_snapshot.flag_snapshot.id  # Using the scenario-specific snapshot
    volume_size = 8  
    volume_type = "gp3"  
    delete_on_termination = true  
  }
  source_ami = "ami-073c5fc1798eb7056" # This is a public Ubuntu AMI
}

# Upload the SSH key to S3
resource "aws_s3_object" "ssh_key_object" {
  bucket  = aws_s3_bucket.scenario_bucket.id
  key     = "ssh_key"
  content = tls_private_key.ssh_key.private_key_pem
}

resource "null_resource" "cleanup_ami_snapshot" {
  triggers = {
    ami_id       = aws_ami.flag_ami.id
    snapshot_id  = aws_ebs_snapshot.flag_snapshot.id
  }

  provisioner "local-exec" {
    when    = destroy
    command = "aws ec2 deregister-image --image-id ${self.triggers.ami_id} && aws ec2 delete-snapshot --snapshot-id ${self.triggers.snapshot_id}"
  }

  depends_on = [aws_ami.flag_ami, aws_ebs_snapshot.flag_snapshot]
}

