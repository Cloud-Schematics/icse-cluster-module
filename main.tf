##############################################################################
# Create IKS on VPC Cluster
##############################################################################

resource "ibm_container_vpc_cluster" "cluster" {

  name              = "${var.prefix}-roks-cluster"
  vpc_id            = var.vpc_id
  resource_group_id = var.resource_group_id
  flavor            = var.machine_type
  worker_count      = var.workers_per_zone
  kube_version      = var.kube_version
  tags              = var.tags
  wait_till         = var.wait_till
  entitlement       = var.entitlement
  cos_instance_crn  = var.cos_instance_crn
  pod_subnet        = var.pod_subnet
  service_subnet    = var.service_subnet

  dynamic "zones" {
    for_each = var.subnet_zone_list
    content {
      subnet_id = zones.value.id
      name      = zones.value.zone
    }
  }

  dynamic "kms_config" {
    for_each = var.kms_config.use_key_protect == true ? [var.kms_config] : []
    content {
      crk_id           = kms_config.value.key_id
      instance_id      = kms_config.value.instance_guid
      private_endpoint = kms_config.value.private_endpoint
    }
  }

  disable_public_service_endpoint = var.disable_public_service_endpoint

  timeouts {
    create = "3h"
    delete = "2h"
    update = "3h"
  }
}

##############################################################################

##############################################################################
# Enable Private ALBs
##############################################################################

resource "ibm_container_vpc_alb" "private_alb" {
  for_each = var.enable_private_albs != true ? {} : {
    for load_balancer in ibm_container_vpc_cluster.cluster.albs :
    (load_balancer.name) => load_balancer if load_balancer.alb_type == "private"
  }
  alb_id = each.value.id
  enable = true
}

##############################################################################

##############################################################################
# Enable Public ALBs
##############################################################################

resource "ibm_container_vpc_alb" "publice_alb" {
  for_each = var.enable_public_albs != true ? {} : {
    for load_balancer in ibm_container_vpc_cluster.cluster.albs :
    (load_balancer.name) => load_balancer if load_balancer.alb_type == "public"
  }
  alb_id = each.value.id
  enable = true
}

##############################################################################