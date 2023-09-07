variable "application" {
  description = "name of the elasticbeanstalk application"
  type        = string
}

variable "environment" {
  description = "environment name : dev, prod...etc"
  type        = string
}

variable "solution_stack" {
  description = "platform name use to run the app"
  type        = string
}

variable "command_timeout" {
  description = "The amount of time, in seconds, to wait for an instance to complete executing commands."
  type        = string
  default     = "900"
}

variable "vpc" {
  description = "VPC where elasticbeanstalk will be created"
  type        = string
}

variable "loadbalancer_security_groups" {
  description = "A list of security groups to attach to the load balancer."
  type        = string
  default     = ""
}

variable "autoscaling_security_groups" {
  description = "Lists the Amazon EC2 security groups to assign to the EC2 instances in the Auto Scaling group to define firewall rules for the instances."
  type        = string
  default     = ""
}

variable "subnets" {
  description = "subnets in a VPC separated by comma"
  type        = string
}

variable "notification_endpoint" {
  description = "The endpoint where you want to be notified of important events affecting your application."
  type        = string
}

variable "notification_topic_arn" {
  description = "The Amazon Resource Name (ARN) for the topic you subscribed to."
  type        = string
}

variable "ssh_source_restriction" {
  description = "Used to lock down SSH access to an environment."
  type        = string
}

variable "ssh_access_key" {
  description = "ssh key use to access ec2 instances"
  type        = string
}

variable "instance_types" {
  description = "list of instances to use separated by a coma"
  type        = string
  default     = "t3.micro, t3.small"
}

variable "min_instance" {
  description = "minimum number of instances to run at any given moment"
  type        = number
  default     = 1
}

variable "max_instance" {
  description = "maximum number of instances to run at any given moment"
  type        = number
  default     = 4
}

variable "mesure_name" {
  description = "The metric that's used for your Auto Scaling trigger"
  type        = string
  default     = "NetworkOut"
}

variable "statistic" {
  description = "The Statistic the trigger uses"
  type        = string
  default     = "Average"
}

variable "unit" {
  description = "The unit for the trigger measurement"
  type        = string
  default     = "Bytes"
}

variable "upper_threshold" {
  description = "If the measurement is higher than this number for the breach duration, a trigger is invoked."
  type        = number
  default     = 6000000
}

variable "upper_breach_scale_increment" {
  description = "Specifies how many Amazon EC2 instances to add when performing a scaling activity."
  type        = number
  default     = 1
}

variable "lower_threshold" {
  description = "If the measurement falls below this number for the breach duration, a trigger is invoked."
  type        = number
  default     = 2000000
}

variable "lower_breach_scale_increment" {
  description = "How many Amazon EC2 instances to remove when performing a scaling activity."
  type        = number
  default     = -1
}

variable "breach_duration" {
  description = "The amount of time, in minutes, a metric can be beyond its defined limit"
  type        = number
  default     = 5
}

variable "period" {
  description = "Specifies how frequently Amazon CloudWatch measures the metrics for your trigger. The value is the number of minutes between two consecutive periods."
  type        = number
  default     = 5
}

variable "healthcheck_endpoint" {
  description = "path to health check"
  type        = string
  default     = "/"
}

variable "application_variables" {
  description = "environment variables for the application"
  type        = map(string)
  default     = {}
}

variable "cloudflare_zone_id" {
  description = "wemap zone id of domain in cloudflare"
  type        = string
  sensitive   = true
}

variable "subdomain" {
  description = "desired subdomain for the application"
  type        = string
}

variable "allow_overwrite" {
  description = "Overwrite cloudflare dns record"
  type        = bool
  default     = false
}