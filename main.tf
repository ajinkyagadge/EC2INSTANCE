terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
}

provider "aws" {
  region     = "ap-south-1"
  access_key = "AKIATVG6GZRFJIOWEBXR"
  secret_key = "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"
}

resource "tls_private_key" "rsa_4096" {                          // To Generate Private Key
  algorithm = "RSA"
  rsa_bits  = 4096
}

variable "key_name" {}

resource "aws_key_pair" "key_pair" {                            // Create Key Pair for Connecting EC2 via SSH
  key_name   = var.key_name
  public_key = tls_private_key.rsa_4096.public_key_openssh
}

resource "local_file" "private_key" {                          // Save PEM file locally
  content  = tls_private_key.rsa_4096.private_key_pem
  filename = var.key_name
}

resource "aws_instance" "public_instance" {
  ami                    = "ami-04708942c263d8190"
  instance_type          = "t2.medium"
  key_name               = aws_key_pair.key_pair.key_name

  tags = {
    Name = "public_instance"
  }
}