output "eks_cluster_name" {
  value = aws_eks_cluster.this.name
}

output "eip-mysql-dev-0" {
   value = aws_eip.eip-mysql-dev-0.public_ip
}

output "eip-mysql-dev-1" {
   value = aws_eip.eip-mysql-dev-1.public_ip
}


/*
output "ecs_cluster_name" {
  value = aws_ecs_cluster.app_cluster.name
}

output "ecs_task_definition" {
  value = aws_ecs_task_definition.app.family
}

output "alb_dns_name" {
  value = aws_lb.app.dns_name
}
*/

