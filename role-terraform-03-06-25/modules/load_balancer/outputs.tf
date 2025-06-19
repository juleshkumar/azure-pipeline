output "load_balancer_dns_name" {
  description = "The DNS name of the load balancer"
  value       = aws_lb.load_balancer.dns_name
}

output "lb_security_group" {
  value = aws_security_group.tf-sg.id
}

output "lb_arn" {
  value = aws_lb.load_balancer.arn
}

output "lb_target_arn" {
  value = aws_lb_target_group.tg.arn
}