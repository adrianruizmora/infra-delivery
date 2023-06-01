//declared as TF_VAR
variable "cloudflare_zone_id" {
  description = "wemap zone id of domain in cloudflare"
  type        = string
}

//declared as TF_VAR
variable "subdomain" {
  description = "desired subdomain for the application"
  type        = string
}

//declared as TF_VAR
variable "eb_app_cname" {
  description = "cname of elasticbeanstalk application"
  type        = string
}

//declared as TF_VAR
variable "cloudflare_api_token" {
  description = "cloudflare api token"
  type        = string
}