output "vpc_id" {
  value = "${aws_vpc.vpc.id}"
}

output "public_subnets_id" {
 # value = ["${aws_subnet.public.public_subnet.*.id}"]
   value = ["${aws_subnet.public.*.id}"]
}
