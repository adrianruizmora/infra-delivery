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
