output "eb_app_cname" {
  value = aws_elastic_beanstalk_environment.compute.cname
}

output "eb_autoscaling_groups" {
  value = aws_elastic_beanstalk_environment.compute.autoscaling_groups
}