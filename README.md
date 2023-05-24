# Description 

Deploy FAST and EASY your applications adding CI/CD, IaC, immutable deployments and scalable environments in AWS cloud and Cloudflare.
Everything is AUTOMATICALLY added to your projects !
This project aims to abstract some concepts of DevOps so you can focus on writting code !


This is will be a central repo for custom terraform modules as well as a tool that lets you create entire deployment pipelines for your projects.

## Templates

Set of required and configurable files that will be copied to a new project in order to add a pipeline.

## Useful commands

Retrieve Solution Stacks to set variable in **templates/set_tf_vars.sh** script

```sh
    aws elasticbeanstalk list-available-solution-stacks --query "SolutionStacks"
```