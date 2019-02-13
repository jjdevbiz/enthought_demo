resource "aws_elasticache_cluster" "redis" {
  cluster_id           = "sourcegraph"
  security_group_ids = ["${aws_security_group.redis.id}"]
  engine               = "redis"
  node_type            = "cache.t2.medium"
  num_cache_nodes      = 1
  parameter_group_name = "default.redis5.0"
  port                 = 6379
}

resource "aws_security_group" "redis" {
  name = "redis"
  description = "ElastiCache redis servers"
  ingress {
    from_port = 6379
    to_port = 6379
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
