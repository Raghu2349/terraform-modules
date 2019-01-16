resource "aws_iam_role" "ecs-service-role1" {
    name                = "ecs-service-role1-${var.projectName}-${var.environment}"
    path                = "/"
    assume_role_policy  = "${data.aws_iam_policy_document.ecs-service-policy.json}"
   # assume_role_policy = <<EOF
   # {
   #	"Version": "2012-10-17",
   #	"Statement": [
   # 	 {
   #   		"Action": "sts:AssumeRole",
   #   		"Principal": {
   #     	"Service": "ecs.amazonaws.com"
   #   	  },
   #   	  "Effect": "Allow",
   #   	  "Sid": ""
   #	  }
   #	]
   #}
   #EOF
 }

 
 resource "aws_iam_role_policy_attachment" "ecs-service-role-attachment" {
    role       = "${aws_iam_role.ecs-service-role1.name}"
    policy_arn = "arn:aws:iam::aws:policy/service-role/AmazonEC2ContainerServiceRole"
}

data "aws_iam_policy_document" "ecs-service-policy" {
    statement {
    actions = ["sts:AssumeRole"]
    principals {
    type        = "Service"
    identifiers = ["ec2.amazonaws.com"]
            
      }
     } 
    
}

resource "aws_iam_instance_profile" "ecs-instance-profile" {
name = "ecs-instance-profile-${var.projectName}-${var.environment}-1"
path = "/"
role = "${aws_iam_role.ecs-service-role1.id}"
provisioner "local-exec" {
command = "sleep 60"
}
}

resource "aws_iam_role_policy" "ecs_ingest" { 
  name = "ecs_instance_role1-${var.projectName}-${var.environment}"
  role = "${aws_iam_role.ecs-service-role1.id}"
  policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Action": [
        "ecs:DeregisterContainerInstance",
        "ecs:DiscoverPollEndpoint",
        "ecs:Poll",
        "ecs:RegisterContainerInstance",
        "ecs:StartTelemetrySession",
        "ecs:Submit*",
        "ecr:GetAuthorizationToken",
        "ecr:BatchCheckLayerAvailability",
        "ecr:GetDownloadUrlForLayer",
        "ecr:BatchGetImage",
        "ecs:StartTask",
        "logs:CreateLogStream",
        "logs:PutLogEvents",
        "logs:DescribeLogStreams",
        "logs:GetLogEvents"
      ],
      "Resource": "*"
    }
  ]
}
EOF
}


resource "aws_iam_role" "ecs-service-role2" {
    name                = "ecs-service-role2-${var.projectName}-${var.environment}"
    path                = "/"
    assume_role_policy  = "${data.aws_iam_policy_document.ecs-service-policy2.json}"
  
 }
 	
resource "aws_iam_role_policy_attachment" "ecs-service-role-attachment2" {
    role       = "${aws_iam_role.ecs-service-role2.name}"
    policy_arn = "arn:aws:iam::aws:policy/service-role/AmazonEC2ContainerServiceRole"
}

data "aws_iam_policy_document" "ecs-service-policy2" {
    statement {
    actions = ["sts:AssumeRole"]
    principals {
    type        = "Service"
    identifiers = ["ecs.amazonaws.com"]
            
      }
        
  }
}
