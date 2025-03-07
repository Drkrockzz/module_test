## we need to refresh the module output in the root module directory in order to get module output

output "instance_id" {
  value = module.ec2_instance.instance_id
}

output "instance_type"{
  value = module.ec2_instance.instance_ip
}
