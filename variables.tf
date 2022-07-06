##############################################################################
# Module Level Variables
##############################################################################

variable "region" {
  description = "The region to which to deploy the VPC"
  type        = string
}

variable "prefix" {
  description = "The prefix that you would like to prepend to your resources"
  type        = string
}

variable "resource_group_id" {
  description = "Resource group ID where the cluster will be provisioned."
  type        = string
  default     = null
}

variable "tags" {
  description = "List of Tags for the resource created"
  type        = list(string)
  default     = null
}

##############################################################################

##############################################################################
# VPC Variables
##############################################################################

variable "vpc_id" {
  description = "ID of the VPC where the cluster will be provisioned"
  type        = string
}

variable "subnet_zone_list" {
  description = "List of subnets in the VPC where gateways and reserved IPs will be provisioned. This value is intended to use the `subnet_zone_list` output from the ICSE VPC Subnet Module (https://github.com/Cloud-Schematics/vpc-subnet-module) or from templates using that module for subnet creation."
  type = list(
    object({
      name = string
      id   = string
      zone = optional(string)
      cidr = optional(string)
    })
  )
}

##############################################################################

##############################################################################
# Services Variables
##############################################################################

variable "kms_config" {
  description = "OPTIONAL - Key Protect Configuration for cluster"
  type = object({
    use_key_protect  = bool
    key_id           = optional(string)
    instance_guid    = optional(string)
    private_endpoint = optional(bool)
  })
  default = {
    use_key_protect = false
  }
}

##############################################################################

##############################################################################
# Cluster Variables
##############################################################################

variable "machine_type" {
  description = "The flavor of VPC worker node to use for your cluster. Use `ibmcloud ks flavors` to find flavors for a region."
  type        = string
  default     = "bx2.4x16"
}

variable "workers_per_zone" {
  description = "Number of workers to provision in each subnet. OpenShift clusters require at least 2 workers. These workers can be spread across multiple zones."
  type        = number
  default     = 2
}

variable "kube_version" {
  description = "Specify the Kubernetes version, including the major.minor version. To see available versions, run `ibmcloud ks versions`. To use the default version, leave as `default`."
  type        = string
  default     = "default"
}

variable "pod_subnet" {
  description = "Specify a custom subnet CIDR to provide private IP addresses for pods. The subnet must have a CIDR of at least /23 or larger."
  type        = string
  default     = "172.30.0.0/16"
}

variable "service_subnet" {
  description = "Specify a custom subnet CIDR to provide private IP addresses for services. The subnet must be at least ’/24’ or larger."
  type        = string
  default     = "172.21.0.0/16"
}


variable "wait_till" {
  description = "To avoid long wait times when you run your Terraform code, you can specify the stage when you want Terraform to mark the cluster resource creation as completed. Depending on what stage you choose, the cluster creation might not be fully completed and continues to run in the background. However, your Terraform code can continue to run without waiting for the cluster to be fully created. Supported args are `MasterNodeReady`, `OneWorkerNodeReady`, and `IngressReady`"
  type        = string
  default     = "IngressReady"

  validation {
    error_message = "`wait_till` value must be one of `MasterNodeReady`, `OneWorkerNodeReady`, or `IngressReady`."
    condition = contains([
      "MasterNodeReady",
      "OneWorkerNodeReady",
      "IngressReady"
    ], var.wait_till)
  }
}

variable "update_all_workers" {
  description = "Update all workers to new kube version"
  type        = bool
  default     = false
}

variable "disable_public_service_endpoint" {
  description = "Disable the public service endpoint on the cluster."
  type        = bool
  default     = false
}

##############################################################################

##############################################################################
# OpenShift Cluster Variables
##############################################################################

variable "entitlement" {
  description = "OPENSHIFT CLUSTERS ONLY - If you purchased an IBM Cloud Cloud Pak that includes an entitlement to run worker nodes that are installed with OpenShift Container Platform, enter entitlement to create your cluster with that entitlement so that you are not charged twice for the OpenShift license. Note that this option can be set only when you create the cluster. After the cluster is created, the cost for the OpenShift license occurred and you cannot disable this charge."
  type        = string
  default     = null
}

variable "cos_instance_crn" {
  description = "OPENSHIFT CLUSTERS ONLY - CRN of the COS Instnance for the cluster to use."
  type        = string
  default     = null
}

##############################################################################