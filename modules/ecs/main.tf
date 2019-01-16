/*====
Cloudwatch Log Group
======*/
resource "aws_cloudwatch_log_group" "openjobs" {
  name = "${var.projectName}-${var.environment}-logs"

  tags {
    Environment = "${var.environment}"
    Application = "OpenJobs"
  }
}



resource "aws_security_group" "instance" {
  name        = "${var.environment}_${var.cluster}_${var.instance_group}"
  description = "Used in ${var.environment}"
  vpc_id      = "${var.vpc_id}"

  tags {
    Environment   = "${var.environment}"
    Cluster       = "${aws_ecs_cluster.cluster.id}"
    InstanceGroup = "${var.instance_group}"
  }
}	


# Default ALB implementation that can be used connect ECS instances to it

resource "aws_alb_target_group" "default" {
  #name                 = "DevGearup-TF"
  name				    = "${var.projectName}-${var.environment}-TF"
  #"${var.alb_name}-default"
  #port                 = 3000
  port                 =80
  protocol             = "HTTP"
  vpc_id               = "${var.vpc_id}"
  #deregistration_delay = "${var.deregistration_delay}"

  health_check {
    path     = "/api/status"
    #"${var.health_check_path}" 
    protocol = "HTTP"
  }

  tags {
    Environment = "${var.environment}"
  }
}

resource "aws_alb" "alb" {
 # name            = "${var.alb_name}"
  name            = "${var.projectName}-${var.environment}-ALB"
  internal        = false
  load_balancer_type = "application"
  subnets         = ["${var.public_subnets_ids}"]
  security_groups = ["${aws_security_group.alb.id}"]

  tags {
    Environment = "${var.environment}"
  }
}


resource "aws_alb_listener" "https" {
  load_balancer_arn = "${aws_alb.alb.id}"
  port              = "80"
  protocol          = "HTTP"

  default_action {
    target_group_arn = "${aws_alb_target_group.default.id}"
    type             = "forward"
  }
}


resource "aws_security_group" "alb" {
 # name   = "${var.alb_name}_alb"
 #  name    = "${aws_alb.alb.name}-ASG"
  name	  = "${var.projectName}-${var.environment}-ASG"
  vpc_id = "${var.vpc_id}"

  tags {
    Environment = "${var.environment}"
  }
}

resource "aws_security_group_rule" "https_from_anywhere" {
  type              = "ingress"
  from_port         = 80
  to_port           = 80
#  from_port          = 3000
#   to_port           = 3000
  protocol          = "TCP"
  cidr_blocks       = ["${var.allow_cidr_block}"]
  security_group_id = "${aws_security_group.alb.id}"
}

resource "aws_security_group_rule" "outbound_internet_access" {
  type              = "egress"
  from_port         = 0
  to_port           = 0
  protocol          = "-1"
  cidr_blocks       = ["0.0.0.0/0"]
  security_group_id = "${aws_security_group.alb.id}"
}


resource "aws_security_group" "inst" {
  name   = "SG_Instance_TF-${var.projectName}-${var.environment}"
  vpc_id = "${var.vpc_id}"

  tags {
    Environment = "${var.environment}"
  }
}

resource "aws_security_group_rule" "ingrules" {

  #name = "${var.projectName}-${var.environment}-ASG"
  #description = "Security Group Name"
  
  type              = "ingress"
  from_port         = 80
  to_port           = 80
  protocol          = "TCP"
  cidr_blocks       = ["${var.allow_cidr_block}"]
  security_group_id = "${aws_security_group.inst.id}"
 
  
}

resource "aws_security_group_rule" "ingrules1" {

  #name = "${var.projectName}-${var.environment}-ASG"
  #description = "Security Group Name"
  
  type              = "ingress"
  from_port         = 22
  to_port           = 22
  protocol          = "TCP"
  cidr_blocks       = ["${var.allow_cidr_block}"]
  security_group_id = "${aws_security_group.inst.id}"
 
  
}

resource "aws_security_group_rule" "egresrules" {
  type              = "egress"
  from_port         = 0
  to_port           = 0
  protocol          = "-1"
  cidr_blocks       = ["0.0.0.0/0"]
  security_group_id = "${aws_security_group.inst.id}"
}


## Key Pair Creation ########

#resource "aws_key_pair" "key" {
#  key_name   = "r.kadari"
#  public_key = "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQC7Jczj9ZjpWXoTqQKE6B3bzy+hEyGviA/4nD3JVmLTLPGUNn2owvampByfafEaMuBMJia7B7e9hVtnlrMcIHAfFWkl4a5W2upeGs7uM8LXfrQcdN8a/WOy/gEAiYQsZ3WDT3kMDV4jMJ7PxL5yLbK/xIDqeWnUNf6zRkmh70l3uiRAC0DBhBKJx4pt0swKhoiCBDN3fIq4bpeEMMoPlxjyWixwNodz46h5nuucr7XeMjLH950edNewmegW7wD7R7Li7NImoRDrEY1J8vUTkcWNjddwNGhLUupzhtLTpkj6DXF5dk9T6a5eavai0meMRZdhrMlH9lLE4T7kKcESJ1Vl r.kadari@2030007599"
  #"${file("production_key.pub")}"
#}


#data "template_file" "userdata_master" {
#  template = "${file("../../modules/ecs/userdata.sh")}"
#}

#data "template_cloudinit_config" "master" {
  
 

  # get master user_data
 # part {
 #   filename     = "userdata.sh"
 #   content_type = "text/part-handler"
 #   content      = "${data.template_file.userdata_master.rendered}"
 # }

#}



## Launch Configuration #######

resource "aws_launch_configuration" "ecs-launch-configuration" {
    name                        = "ecs-launch-configuration-${var.projectName}-${var.environment}"
    #image_id                    =  #"ami-09a64272e7fe706b6"
    image_id          			= "${lookup(var.amis, var.region)}"
    instance_type               = "${var.instance_type}"
    iam_instance_profile        = "${aws_iam_instance_profile.ecs-instance-profile.id}"

    root_block_device {
      volume_type = "${var.rootvoltype}"
      volume_size = "${var.rootvolsize}"
      delete_on_termination = true
    }

    lifecycle {
      create_before_destroy = true
    }
    

    security_groups             = ["${aws_security_group.inst.id}"]
    associate_public_ip_address = "true"
    #key_name                    = "${aws_key_pair.key.id}"
    key_name					 =  "tfgearup-key"
   #"testone", testpoc
    # user_data                   = <<EOF
    #                               #!/bin/bash
    #                               echo ECS_CLUSTER=${aws_ecs_cluster.cluster.id} >> /etc/ecs/ecs.config
    #                               EOF
                                   
                                   
   
    user_data       			 = "${file("../../terraform-modules/modules/ecs/userdata.sh")}"    
    
   # file("${path.module}/file"). 
   #${file("path.txt")}/ file("${path.module}/file").                          
   
 #  user_data = <<EOF
 #                   /etc/ecs/ecs.config
 #			   EOF
}


