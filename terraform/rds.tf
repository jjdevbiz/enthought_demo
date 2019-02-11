resource "aws_rds_cluster" "postgresql" {
  cluster_identifier      = "aurora-cluster-demo"
  engine                  = "aurora-postgresql"
  availability_zones      = ["us-east-1a", "us-east-1b", "us-east-1c"]
  database_name           = "sourcegraphdb"
  master_username         = "${var.rds_username}"
  master_password         = "${var.rds_password}"
  backup_retention_period = 5
  preferred_backup_window = "07:00-09:00"
}
