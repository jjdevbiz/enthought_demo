# Ubuntu Server 18.04 LTS (HVM), SSD Volume Type - ami-0f65671a86f061fcd (64-bit x86)

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
  #delete_on_termination = "true"
  #volume_size   = "20"
  #volume_type   = "standard"
  key_name      = "default"
  associate_public_ip_address = "true"
  monitoring    = "true"
  #subnet_id     = "us-east-1a"
  subnet_id     = "subnet-058be759"

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
    content     = "PGHOST=${aws_rds_cluster.postgresql.endpoint} PGUSER=${aws_rds_cluster.postgresql.master_username} PGPASSWORD=${aws_rds_cluster.postgresql.master_password} PGDATABASE=${aws_rds_cluster.postgresql.database_name} PGSSLMODE=false REDIS_ENDPOINT=${aws_elasticache_cluster.redis.cluster_address}:${aws_elasticache_cluster.redis.port}"
    destination = "/tmp/dotenv"
  }


  user_data = "${file("userdata/sourcegraph.sh")}"

  tags = {
    Name = "sourcegraph"
  }
}
