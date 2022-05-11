
output "vpc_id" {
  value = ["${module.vpc.vpc_id}"]
}

output "vpc_public_subnets" {
  value = ["${module.vpc.public_subnets}"]
}

output "webserver_ids" {
  value = ["${aws_instance.webserver.*.id}"]
}

output "ip_addresses" {
  value = ["${aws_instance.webserver.*.public_ip}"]
}