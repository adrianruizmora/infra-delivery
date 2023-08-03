# provider "cloudflare" {
#   api_token = var.cloudflare_api_token
# }

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
}

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
    namespace = "aws:elbv2:loadbalancer"
    name      = "ManagedSecurityGroup"
    value     = var.aws_security_group.AllowOnlyCloudflareProxyIps.id
  }

  setting {
    namespace = "aws:elbv2:loadbalancer"
    name      = "SecurityGroups"
    value     = var.security_groups == "" ? var.aws_security_group.AllowOnlyCloudflareProxyIps.id : "${var.security_groups},${var.aws_security_group.AllowOnlyCloudflareProxyIps.id}"
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

  dynamic "setting" {
    for_each = var.application_variables
    content {
      namespace = "aws:elasticbeanstalk:application:environment"
      name      = setting.key
      value     = setting.value
    }
  }

}

resource "cloudflare_record" "compute" {
  zone_id = var.cloudflare_zone_id
  name    = var.subdomain
  value   = immutable_elasticbeanstalk.eb_app_cname
  type    = "CNAME"
  proxied = true
}