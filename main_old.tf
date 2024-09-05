module "ec2_instances" {
  source        = "../terraform-lab-7"
  aws_region    = "us-west-1"
  instance_type = "t2.micro"
  instance_count = 2
}

output "module_instance_public_ips" {
  value = module.ec2_instances.instance_public_ips
}
