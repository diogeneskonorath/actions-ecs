variable "app_name" {}
variable "dns_name" {}
variable "cluster_name" {}
variable "create_cluster" {}
variable "container_port" {}

variable "type" {}
variable "load_balancer_type" {}
variable "private_access" {}
variable "healthcheck_url" {}

variable "ingress_ports_app" {}
variable "egress_ports_app" {}
variable "ingress_allowed_cidrs_app" {}
variable "egress_allowed_cidrs_app" {}
variable "app" {}

variable "ingress_ports_lb" {}
variable "egress_ports_lb" {}
variable "ingress_allowed_cidrs_lb" {}
variable "egress_allowed_cidrs_lb" {}
variable "lb" {}

variable "project" {}
variable "team" {}

variable "env" {}
variable "region" {}

variable "vpc_name" {}
variable "private_subnets" {}
variable "public_subnets" {}

variable "certificate" {}
variable "domain" {}

variable "task_cpu" {}
variable "task_memory" {}