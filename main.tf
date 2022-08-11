data "template_file" "shell-script" {
  template = "${file("scripts/gitlab.sh")}"
}

# Render a part using a "template_file" for customizing gitlab configuration
data "template_file" "gitlab_application_user_data" {
  template = "${file("templates/gitlab_application_user_data.tpl")}"
  vars = {
    postgres_database = aws_db_instance.gitlab_postgres.name
    postgres_username = aws_db_instance.gitlab_postgres.username
    postgres_password = var.gitlab_postgresql_password
    postgres_endpoint = aws_db_instance.gitlab_postgres.address
    redis_endpoint = aws_elasticache_replication_group.gitlab_redis.primary_endpoint_address
    cidr = var.vpc_cidr
    gitlab_url = "http://${aws_lb.alb_apps.dns_name}"
  }
}

# Render a multi-part cloudinit config making use of the part above, and other source files
data "template_cloudinit_config" "config" {
  gzip = false
  base64_encode = false
  part {
    filename = "gitlab_application_user_data.tpl"
    content_type = "text/cloud-config"
    content = data.template_file.gitlab_application_user_data.rendered
  }
  part {
    content_type = "text/x-shellscript"
    content = data.template_file.shell-script.rendered
  }
}

data "aws_ami" "rhel" {
  most_recent = true

  filter {
    name   = "name"
    values = ["RHEL-8.6.0_HVM-*"]
  }
  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }
  filter {
    name   = "root-device-type"
    values = ["ebs"]
  }
  filter {
    name   = "architecture"
    values = ["x86_64"]
  }
  owners = ["309956199498"] // Red Hat's Account ID
}

data "aws_ami" "amzn" {
  most_recent = true

  filter {
    name   = "name"
    values = ["amzn2-ami-hvm-2.0*"]
  }
  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }
  filter {
    name   = "root-device-type"
    values = ["ebs"]
  }
  owners = ["amazon"] # Canonical
}


resource "aws_instance" "bastion" {
  ami = data.aws_ami.amzn.id
  instance_type = "t2.micro"
  key_name = aws_key_pair.devops.id
  subnet_id = aws_subnet.public-subnet.id
  vpc_security_group_ids = [ aws_security_group.sgbastion.id ]
  associate_public_ip_address = true
  tags = {
    Name = "Bastion"
  }
}

output "Gitlab_One-Time_DB_Creation_Command-Primary_Only" {
    value = "force=yes; export force; gitlab-rake gitlab:setup"
}

output "Gitlab_One-Time_DB_Creation_Command-Primary_Only_2" {
    value = "sudo gitlab-ctl reconfigure"
}

output "Bastion_Public_IP" {
    value = aws_instance.bastion.public_ip
}

output "DevOps_Apps_Public_IP" {
    value = aws_lb.alb_apps.dns_name
}