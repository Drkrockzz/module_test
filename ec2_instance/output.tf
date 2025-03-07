output "instance_id" {
  value = aws_instance.m_ec2.host_id
}

output "instance_ip" {
    value = aws_instance.m_ec2.public_ip
}