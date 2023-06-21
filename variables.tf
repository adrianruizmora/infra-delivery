//declared as TF_VAR
variable "application" {
  description = "name of the elasticbeanstalk application"
  type        = string
}

//declared as TF_VAR
variable "environment" {
  description = "environment name : dev, prod...etc"
  type        = string
}

// declared as TF_VAR
variable "solution_stack" {
  description = "platform name use to run the app"
  type        = string
}

// declared at runtime ?
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
