resource "aws_ecr_repository" "nginx" {
name = "nginx"
}

output "nginx-repository-URL" {
value = "${aws_ecr_repository.nginx.repository_url}"
}

resource "aws_ecr_repository" "sourcegraph" {
name = "sourcegraph"
}

output "sourcegraph-repository-URL" {
value = "${aws_ecr_repository.sourcegraph.repository_url}"
}
