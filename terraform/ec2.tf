data "aws_ami" "ubuntu" {
  most_recent = true

  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd/ubuntu-bionic-18.04-amd64-server-*"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }

  owners = ["099720109477"] # Canonical
}

resource "aws_instance" "web" {
  ami           = "${data.aws_ami.ubuntu.id}"
  instance_type = "t2.large"
  key_name      = "default"
  associate_public_ip_address = "true"
  monitoring    = "true"
  security_groups = ["${aws_security_group.ec2.id}","${aws_security_group.sourcegraph-mgmt.id}"]
  subnet_id     = "${var.defaultSubnet}"

  connection {
    type        = "ssh"
    user        = "ubuntu"
    }

  # I can get an env key onto the instance with local-exec:
  provisioner "file" {
    content     = "${var.secretHash}"
    destination = "/tmp/secretHash.txt"
  }

  provisioner "file" {
# aws_elasticache_cluster.redis.cache_nodes.0.address
    content     = "PGHOST=${aws_rds_cluster.postgresql.endpoint} PGUSER=${aws_rds_cluster.postgresql.master_username} PGPASSWORD=${aws_rds_cluster.postgresql.master_password} PGDATABASE=${aws_rds_cluster.postgresql.database_name} PGSSLMODE=disable REDIS_ENDPOINT=${aws_elasticache_cluster.redis.cache_nodes.0.address}:${aws_elasticache_cluster.redis.port}"
    destination = "/tmp/dotenv"
  }

  user_data = "${file("userdata/sourcegraph.sh")}"

  tags = {
    Name = "sourcegraph"
  }
}

resource "aws_security_group" "ec2" {
  name = "ec2"
  description = "ec2 general servers"
  ingress {
    from_port = 22
    to_port = 22
    protocol = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  ingress {
    from_port = 80
    to_port = 80
    protocol = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  ingress {
    from_port = 443
    to_port = 443
    protocol = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  egress {
    from_port = 0
    to_port = 0
    protocol = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_security_group" "sourcegraph-mgmt" {
  name = "sourcegraph-mgmt"
  description = "ec2 general servers"
  ingress {
    from_port = 2633
    to_port = 2633
    protocol = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  egress {
    from_port = 0
    to_port = 0
    protocol = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}
