/*====
ECR repository to store our Docker images
======*/
resource "aws_ecr_repository" "openjobsapp" {
  #name = "${var.repository_name}"
  name = "${lower(var.projectName)}-${lower(var.environment)}"
}

/*====
ECS cluster
======*/
resource "aws_ecs_cluster" "cluster" {
  name = "${var.projectName}_${var.environment}_Cluster"
}


/*====
ECS task definitions
======*/

# DevGearupT = ECSTaskDef

data "aws_ecs_task_definition" "ECSTaskDef" {
  depends_on = [ "aws_ecs_task_definition.ECSTaskDef" ]	
  task_definition = "${aws_ecs_task_definition.ECSTaskDef.family}"
}

resource "aws_ecs_task_definition" "ECSTaskDef" {
    family                = "${var.projectName}_${var.environment}_Task"
    container_definitions = <<DEFINITION
[
  
 {
    "name": "gearup-api",
    "image":"081137044412.dkr.ecr.us-east-1.amazonaws.com/gearup-api:1",
    "essential": true,
    "portMappings": [
      {
        "containerPort": 3000,
        "hostPort": 3000
      }
    ],
    "memory": 2048,
    "cpu": 512,
    "environment": [
      {"name" : "NODE_ENV", "value" : "development"},
      {"name" : "MONGO_URI", "value" : "mongodb://root:SOh3TbYhx8ypJPxmt1oOfL@54.219.174.210:27017/healthhub_development?authSource=admin"}
    ]
    
  },
  {
    "name": "gearup-nginx",
    "links": [
      "gearup-api","gearup-services"
     ],
    "image":"081137044412.dkr.ecr.us-east-1.amazonaws.com/gearup-nginx:0.0.1-SNAPSHOT",
    "essential": false,
    "portMappings": [
      {
        "containerPort": 80,
        "hostPort": 80
      }
    ],
    "memory": 2048,
    "cpu": 512
     
  },
  
  {
    "name": "gearup-services",
    "image":"081137044412.dkr.ecr.us-east-1.amazonaws.com/gearup-services:167",
    "essential": false,
    "portMappings": [
      {
        "containerPort": 3001,
        "hostPort": 3001
      }
    ],
    "memory": 2048,
    "cpu": 1024,
    "environment": [
      {"name" : "MONGO_URL", "value" : "mongodb://root:SOh3TbYhx8ypJPxmt1oOfL@54.219.174.210:27017/healthhub_development?authSource=admin"},
      {"name" : "NODE_ENV", "value" : "development"},
      {"name" : "PORT", "value" : "3001"},
      {"name" : "ROOT_URL", "value" : "http://new-dev.sgearup.com"}
    ]
      
  }
  
  
  
]
DEFINITION
}


resource "aws_ecs_service" "ECS-Service" {
  #	name            = "Gearup-ECS-Service"
    name			= "${var.projectName}-${var.environment}-ECS-Service"
    iam_role        = "${aws_iam_role.ecs-service-role2.name}"
  	cluster         = "${aws_ecs_cluster.cluster.id}"
  	task_definition = "${aws_ecs_task_definition.ECSTaskDef.family}:${max("${aws_ecs_task_definition.ECSTaskDef.revision}", "${data.aws_ecs_task_definition.ECSTaskDef.revision}")}"
  	desired_count   = 1  
  	depends_on = ["aws_alb_target_group.default","aws_alb.alb"]
  
  	

  	load_balancer {
    	target_group_arn  	=  "${aws_alb_target_group.default.id}"
    	container_port    	=  80
    	container_name    	=  "${var.ecs_container_name}"
    	 
    	                        
    	
 	}
  	
}