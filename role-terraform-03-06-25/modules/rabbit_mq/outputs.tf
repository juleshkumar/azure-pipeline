output "broker_id" {
  description = "ID of the RabbitMQ broker"
  value       = aws_mq_broker.rabbitmq_broker.id
}

output "broker_arn" {
  description = "ARN of the RabbitMQ broker"
  value       = aws_mq_broker.rabbitmq_broker.arn
}

output "broker_hostname" {
  description = "Hostname of the RabbitMQ broker"
  value       = aws_mq_broker.rabbitmq_broker.instances[0].endpoints[0]
}
