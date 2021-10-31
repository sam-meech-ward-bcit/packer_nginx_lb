packer {
  required_plugins {
    amazon = {
      version = ">= 1.0.0"
      source  = "github.com/hashicorp/amazon"
    }
  }
}

locals { 
  timestamp = regex_replace(timestamp(), "[- TZ:]", "")
}

source "amazon-ebs" "ss-lb" {
  ami_name      = "ss-lb-${local.timestamp}"
  instance_type = "t2.micro"
  region        = "us-west-1"

  associate_public_ip_address = true

  source_ami_filter {
    filters = {
      name                = "amzn2-ami-hvm-2.*"
      root-device-type    = "ebs"
      virtualization-type = "hvm"
    }
    most_recent = true
    owners      = ["amazon"]
  }
  ssh_username = "ec2-user"
}

build {
  sources = ["source.amazon-ebs.ss-lb"]

  provisioner "file" {
    source = "./nginx.conf"
    destination = "/tmp/nginx.conf"
  }

  provisioner "file" {
    source = "./upstream.conf"
    destination = "/tmp/upstream.conf"
  }

  provisioner "shell" {
    script = "./nginx.sh"
  }
}
