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
  monitoring    = "true"
  subnet_id     = "us-east-1a"
  user_data = "${file("userdata/sourcegraph.sh")}"

  tags = {
    Name = "sourcegraph"
  }
}
