resource "aws_inspector_resource_group" "inspectorGRP" {
  tags {
    #Name = "${var.projectName}-${var.environment}-Inspector-Group"
     Name = "ECS-${var.projectName}-${var.environment}-TF"
     Env  = "Dev"
    
    #bar = inspectorGRP
    #foo = inspectorTarget
    
  }
}


#data "aws_instance" "ec2instance" {}

#Amazon_Inspector_Assessment_0-92jtoPM3_IdzmdSD
#"arn:aws:inspector:us-east-1:316112463485:rulespackage/0-92jtoPM3_IdzmdSD",


#${data.aws_ami.web.tags["Name"]}
#aws_autoscaling_group  ecs-autoscaling-group
#${data.aws_autoscaling_group.ecs-autoscaling-group.tags["Name"]}


resource "aws_inspector_assessment_target" "inspectorTarget" {
  name               = "${var.projectName}-${var.environment}-Assessment-Target-${timestamp()}"
  resource_group_arn = "${aws_inspector_resource_group.inspectorGRP.arn}"
}


resource "aws_inspector_assessment_template" "inspectorTemplate" {
  name       = "${var.projectName}-${var.environment}-Template-${timestamp()}"
  target_arn = "${aws_inspector_assessment_target.inspectorTarget.arn}"
  duration   = 3600

  rules_package_arns = [
    "arn:aws:inspector:us-east-1:316112463485:rulespackage/0-gEjTy7T7",
    "arn:aws:inspector:us-east-1:316112463485:rulespackage/0-rExsr2X8",
    "arn:aws:inspector:us-east-1:316112463485:rulespackage/0-R01qwB5Q",
    "arn:aws:inspector:us-east-1:316112463485:rulespackage/0-gBONHN9h"
   
    
  ]
}


#resource "aws_guardduty_detector" "gaurddutyDetector" {
## count = "${var.guarddutyIndicator == true ? 1 : 0}"
# enable = false
#}

#ECS-RKTest-Dev-TF