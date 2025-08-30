# output "instance_id" {
#   value = aws_instance.example.id
# }
output "ecs_cluster_name" {
  value = aws_ecs_cluster.devops_cluster.name
}