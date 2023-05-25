//declared as TF_VAR
variable "backend_bucket_name" {
  description = "bucket name to store terraform states"
  type        = string
}

//declared as TF_VAR
variable "application" {
  description = "name of the elasticbeanstalk application"
  type        = string
}