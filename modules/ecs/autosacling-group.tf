resource "aws_autoscaling_group" "ecs-autoscaling-group" {
    name                        = "${var.projectName}_${var.environment}_ASG"
    max_size                    ="${var.max_instance_size}"
    min_size                    ="${var.min_instance_size}"
    desired_capacity            ="${var.desired_capacity}"
    #vpc_zone_identifier        =["${aws_subnet.public.*.id}", "${aws_subnet.test_public_sn_02.id}"]
    vpc_zone_identifier         =["${var.public_subnets_ids}"]
    launch_configuration        ="${aws_launch_configuration.ecs-launch-configuration.name}"
    health_check_type           ="ELB"
   
  
  	tag {
			key = "Name"
		    value = "ECS-${var.projectName}-${var.environment}-TF"
			propagate_at_launch = true
		}
	}
	
## Creates the Notification for Auto Sacling Group

resource "aws_autoscaling_notification" "ASG_notifications" {
  group_names = [
    "${aws_autoscaling_group.ecs-autoscaling-group.name}",
    ]

  notifications = [
    "autoscaling:EC2_INSTANCE_LAUNCH",
    "autoscaling:EC2_INSTANCE_TERMINATE",
    "autoscaling:EC2_INSTANCE_LAUNCH_ERROR",
  ]

  topic_arn = "${aws_sns_topic.snstopic.arn}"
}

resource "aws_sns_topic" "snstopic" {
  name = "${var.projectName}_${var.environment}-ASG"

  # arn is an exported attribute
}





