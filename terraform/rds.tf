resource "aws_rds_cluster" "postgresql" {
  vpc_security_group_ids = ["${aws_security_group.postgresql.id}"]
  cluster_identifier      = "sourcegraph1"
  engine                  = "aurora-postgresql"
  availability_zones      = ["us-east-1a", "us-east-1b", "us-east-1c"]
  database_name           = "sourcegraphdb"
  master_username         = "${var.rds_username}"
  master_password         = "${var.rds_password}"
  backup_retention_period = 2
  storage_encrypted = true
  preferred_backup_window = "07:00-09:00"
  skip_final_snapshot = true
  final_snapshot_identifier = "DELETEME"
  engine_version    = "10.6"
}

resource "aws_rds_cluster_instance" "cluster_instances" {
  count              = 1
  identifier         = "sourcegraph-${count.index}"
  cluster_identifier = "${aws_rds_cluster.postgresql.id}"
  instance_class     = "db.r4.large"
  engine_version    = "10.6"
  engine = "aurora-postgresql"
}

resource "aws_security_group" "postgresql" {
  name = "postgresql"
  description = "RDS postgres servers"
  ingress {
    from_port = 5432
    to_port = 5432
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
