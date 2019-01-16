output "ami" {
  value = "${aws_launch_configuration.ecs-launch-configuration.id}"

} 

