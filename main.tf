terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 4.67.0"
    }
    cloudflare = {
      source  = "cloudflare/cloudflare"
      version = "3.31.0"
    }
  }
}

data "cloudflare_ip_ranges" "cloudflare_ranges" {}

resource "aws_security_group" "AllowOnlyCloudflareProxyIps" {
  name        = "AWSEBLoadBalancerSecurityGroup-${var.application}-${var.environment}"
  description = "Accepts ingress traffic from Cloudflare"
  vpc_id      = var.vpc

  ingress {
    description = "Cloudflare traffic"
    protocol    = "tcp"

    cidr_blocks      = data.cloudflare_ip_ranges.cloudflare_ranges.ipv4_cidr_blocks
    ipv6_cidr_blocks = data.cloudflare_ip_ranges.cloudflare_ranges.ipv6_cidr_blocks

    # Using "Full, Full(strict), Strict" SSL? Change to port 443.
    from_port = 80
    to_port   = 80
  }

  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }

  tags = {
    Name = "${var.application}-${var.environment}"
  }
}

# resource "aws_efs_access_point" "efs_access_point" {
#   count          = var.efs_file_system_id != "" ? 1 : 0
#   file_system_id = var.efs_file_system_id
#   posix_user {
#     uid = 1000
#     gid = 1000
#   }
# }

resource "aws_elastic_beanstalk_environment" "compute" {
  name                   = "${var.application}-${var.environment}"
  application            = var.application
  solution_stack_name    = var.solution_stack
  cname_prefix           = "${var.application}-${var.environment}"
  tier                   = "WebServer"
  wait_for_ready_timeout = "20m"

  setting {
    namespace = "aws:ec2:vpc"
    name      = "VPCId"
    value     = var.vpc
  }

  setting {
    namespace = "aws:elasticbeanstalk:command"
    name      = "Timeout"
    value     = var.command_timeout
  }

  setting {
    namespace = "aws:elbv2:loadbalancer"
    name      = "ManagedSecurityGroup"
    value     = aws_security_group.AllowOnlyCloudflareProxyIps.id
  }

  setting {
    namespace = "aws:elbv2:loadbalancer"
    name      = "SecurityGroups"
    value     = var.loadbalancer_security_groups == "" ? aws_security_group.AllowOnlyCloudflareProxyIps.id : "${var.loadbalancer_security_groups},${aws_security_group.AllowOnlyCloudflareProxyIps.id}"
  }

  setting {
    namespace = "aws:autoscaling:launchconfiguration"
    name      = "SecurityGroups"
    value     = var.autoscaling_security_groups
  }

  setting {
    namespace = "aws:ec2:vpc"
    name      = "Subnets"
    value     = var.subnets
  }

  setting {
    namespace = "aws:ec2:vpc"
    name      = "ELBSubnets"
    value     = var.subnets
  }

  setting {
    namespace = "aws:elasticbeanstalk:sns:topics"
    name      = "Notification Endpoint"
    value     = var.notification_endpoint
  }

  setting {
    namespace = "aws:elasticbeanstalk:sns:topics"
    name      = "Notification Topic ARN"
    value     = var.notification_topic_arn
  }

  setting {
    namespace = "aws:autoscaling:launchconfiguration"
    name      = "SSHSourceRestriction"
    value     = var.ssh_source_restriction
  }

  setting {
    namespace = "aws:autoscaling:launchconfiguration"
    name      = "EC2KeyName"
    value     = var.ssh_access_key
  }

  setting {
    namespace = "aws:autoscaling:launchconfiguration"
    name      = "DisableIMDSv1"
    value     = true
  }

  setting {
    namespace = "aws:autoscaling:launchconfiguration"
    name      = "IamInstanceProfile"
    value     = "aws-elasticbeanstalk-ec2-role"
  }

  setting {
    namespace = "aws:elasticbeanstalk:cloudwatch:logs"
    name      = "StreamLogs"
    value     = "true"
  }

  setting {
    namespace = "aws:elasticbeanstalk:cloudwatch:logs"
    name      = "RetentionInDays"
    value     = "30"
  }

  setting {
    namespace = "aws:elasticbeanstalk:cloudwatch:logs"
    name      = "DeleteOnTerminate"
    value     = "false"
  }

  setting {
    namespace = "aws:ec2:instances"
    name      = "InstanceTypes"
    value     = var.instance_types
  }

  setting {
    namespace = "aws:autoscaling:asg"
    name      = "MinSize"
    value     = var.min_instance
  }

  setting {
    namespace = "aws:autoscaling:asg"
    name      = "MaxSize"
    value     = var.max_instance
  }

  setting {
    namespace = "aws:autoscaling:trigger"
    name      = "MeasureName"
    value     = var.mesure_name
  }

  setting {
    namespace = "aws:autoscaling:trigger"
    name      = "Statistic"
    value     = var.statistic
  }

  setting {
    namespace = "aws:autoscaling:trigger"
    name      = "Unit"
    value     = var.unit
  }

  setting {
    namespace = "aws:autoscaling:trigger"
    name      = "UpperThreshold"
    value     = var.upper_threshold
  }

  setting {
    namespace = "aws:autoscaling:trigger"
    name      = "UpperBreachScaleIncrement"
    value     = var.upper_breach_scale_increment
  }

  setting {
    namespace = "aws:autoscaling:trigger"
    name      = "LowerThreshold"
    value     = var.lower_threshold
  }

  setting {
    namespace = "aws:autoscaling:trigger"
    name      = "LowerBreachScaleIncrement"
    value     = var.lower_breach_scale_increment
  }

  setting {
    namespace = "aws:autoscaling:trigger"
    name      = "BreachDuration"
    value     = var.breach_duration
  }

  setting {
    namespace = "aws:autoscaling:trigger"
    name      = "Period"
    value     = var.period
  }

  setting {
    namespace = "aws:autoscaling:updatepolicy:rollingupdate"
    name      = "RollingUpdateType"
    value     = "Immutable"
  }

  setting {
    namespace = "aws:elasticbeanstalk:command"
    name      = "DeploymentPolicy"
    value     = "Immutable"
  }

  setting {
    namespace = "aws:elasticbeanstalk:environment"
    name      = "LoadBalancerType"
    value     = "application"
  }

  setting {
    namespace = "aws:elasticbeanstalk:application"
    name      = "Application Healthcheck URL"
    value     = var.healthcheck_endpoint
  }

  # setting {
  #   namespace = "aws:elasticbeanstalk:application:environment"
  #   name      = "EFS_ACCESS_POINT_ID"
  #   value     = var.efs_file_system_id == "" ? "null" : aws_efs_access_point.efs_access_point[0].id
  # }

  dynamic "setting" {
    for_each = var.application_variables
    content {
      namespace = "aws:elasticbeanstalk:application:environment"
      name      = setting.key
      value     = setting.value
    }
  }

}

# This resource is used to add a rule into an existing security group (created manually)
# And that has been given access to a EFS (manually)
# If the ID of existing security group it's not given
# The creation of this ressource will be skipped.
resource "aws_security_group_rule" "AllowEFSAccess" {
  count                    = var.security_group_id_with_efs_access != "" ? 1 : 0
  security_group_id        = var.security_group_id_with_efs_access
  description              = "${var.application}-${var.environment}"
  type                     = "ingress"
  from_port                = 2049
  to_port                  = 2049
  protocol                 = "tcp"
  source_security_group_id = aws_elastic_beanstalk_environment.compute.autoscaling_groups.id
}

resource "cloudflare_record" "compute" {
  zone_id         = var.cloudflare_zone_id
  name            = var.subdomain
  value           = aws_elastic_beanstalk_environment.compute.cname
  type            = "CNAME"
  proxied         = true
  allow_overwrite = var.allow_overwrite
}