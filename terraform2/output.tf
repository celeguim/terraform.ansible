output "k8s-server" {
  value = aws_instance.k8s-server.public_ip
}
