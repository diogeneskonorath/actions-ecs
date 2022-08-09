terraform {
  required_version = ">= 1.0.0"
  required_providers {
    aws = ">= 4"
  }

  cloud {
    organization = "Dexco"
    workspaces {
      name = "template-ecs-module-${var.env}"
    }
  }
}

provider "aws" {
  region = var.region
}

module "acb" {
  source         = "app.terraform.io/Dexco/acb/aws"
  version        = "1.0.0"
  app_name       = var.app_name
  ecr_account_id = module.identity.account_id
  env            = var.env
  team           = var.team
  project        = var.project
  bucket_arn     = module.s3.bucket_arn
}

module "ecr" {
  source   = "app.terraform.io/Dexco/ecr/aws"
  version  = "1.0.0"
  app_name = var.app_name
  env      = var.env
  team     = var.team
  project  = var.project
}

module "identity" {
  source  = "app.terraform.io/Dexco/identity/aws"
  version = "1.0.0"
}

module "cloudwatch" {
  source   = "app.terraform.io/Dexco/cloudwatch/aws"
  version  = "1.0.0"
  app_name = var.app_name
  env      = var.env
  team     = var.team
  project  = var.project
}

module "vpc" {
  source   = "app.terraform.io/Dexco/vpc/aws"
  version  = "1.0.0"
  vpc_name = var.vpc_name
  env      = var.env
}

module "acm" {
  source      = "app.terraform.io/Dexco/acm/aws"
  version     = "1.0.0"
  certificate = var.certificate
}

module "iam" {
  source  = "app.terraform.io/Dexco/iam/aws"
  version = "1.0.0"
}

module "asg" {
  source       = "app.terraform.io/Dexco/asg/aws"
  version      = "1.0.0"
  cluster_name = var.cluster_name
  service_name = module.service.service_name
}

module "subnet" {
  source          = "app.terraform.io/Dexco/subnet/aws"
  version         = "1.0.0"
  private_subnets = var.private_subnets
  public_subnets  = var.public_subnets
  vpc_id          = module.vpc.vpc_id
}

module "route53" {
  source         = "app.terraform.io/Dexco/route53/aws"
  version        = "1.0.0"
  app_name       = var.app_name
  domain         = var.domain
  dns_name       = var.dns_name
  alias_name     = module.lb.dns_name
  alias_zone_id  = module.lb.zone_id
}

module "lb" {
  source             = "app.terraform.io/Dexco/lb/aws"
  version            = "1.0.0"
  vpc_id             = module.vpc.vpc_id
  app_name           = var.app_name
  env                = var.env
  project            = var.project
  team               = var.team
  type               = var.type
  load_balancer_type = var.load_balancer_type
  private_access     = var.private_access
  security_group_id  = module.sg_lb.security_group_id
  private_subnets    = module.subnet.private_subnets_ids
  public_subnets     = module.subnet.public_subnets_ids
  healthcheck_url    = var.healthcheck_url
  certificate_arn    = module.acm.certificate_arn
}

module "sg_lb" {
  source                = "app.terraform.io/Dexco/sg/aws"
  version               = "1.0.0"
  app_name              = var.app_name
  resource              = var.lb
  ingress_ports         = var.ingress_ports_lb
  egress_ports          = var.egress_ports_lb
  ingress_allowed_cidrs = var.ingress_allowed_cidrs_lb
  egress_allowed_cidrs  = var.egress_allowed_cidrs_lb
  env                   = var.env
  project               = var.project
  team                  = var.team
  region                = var.region
  vpc_id                = module.vpc.vpc_id
}

module "sg_app" {
  source                = "app.terraform.io/Dexco/sg/aws"
  version               = "1.0.0"
  app_name              = var.app_name
  resource              = var.app
  ingress_ports         = var.ingress_ports_app
  egress_ports          = var.egress_ports_app
  ingress_allowed_cidrs = var.ingress_allowed_cidrs_app
  egress_allowed_cidrs  = var.egress_allowed_cidrs_app
  env                   = var.env
  project               = var.project
  team                  = var.team
  region                = var.region
  vpc_id                = module.vpc.vpc_id
}

module "cluster" {
  source         = "app.terraform.io/Dexco/cluster/aws"
  version        = "1.0.0"
  cluster_name   = var.cluster_name
  create_cluster = var.create_cluster
  team           = var.team
  project        = var.project
  env            = var.env
}

module "service" {
  source            = "app.terraform.io/Dexco/service/aws"
  version           = "1.0.0"
  app_name          = var.app_name
  cluster_name      = module.cluster.cluster_name
  security_group_id = module.sg_app.security_group_id
  subnets_ids       = module.subnet.private_subnets_ids
  tg_arn            = module.lb.tg_arn
  container_port    = var.container_port
  env               = var.env
  task_family       = module.task_definition.task_family
  task_revision     = module.task_definition.task_revision
}

module "task_definition" {
  source         = "app.terraform.io/Dexco/task/aws"
  version        = "1.0.0"
  app_name       = var.app_name
  ecr_account_id = module.identity.account_id
  task_cpu       = var.task_cpu
  task_memory    = var.task_memory
  region         = var.region
  iam_role       = module.iam.role_arn
  container_port = var.container_port
  env            = var.env
  team           = var.team
  project        = var.project
}



module "s3" {
  source   = "app.terraform.io/Dexco/s3/aws"
  version  = "1.0.0"
  app_name = var.app_name
  env      = var.env
  team     = var.team
  project  = var.project
}