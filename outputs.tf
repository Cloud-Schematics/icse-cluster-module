##############################################################################
# Cluster Outputs
##############################################################################

output "cluster_id" {
  description = "ID of the cluster"
  value       = ibm_container_vpc_cluster.cluster.id
}

output "cluster_crn" {
  description = "ID of the cluster"
  value       = ibm_container_vpc_cluster.cluster.crn
}

output "cluster_name" {
  description = "Name of the cluster"
  value       = ibm_container_vpc_cluster.cluster.name
}

output "ingress_hostname" {
  description = "Hostname for ingress subdomain."
  value       = ibm_container_vpc_cluster.cluster.ingress_hostname
}

output "private_service_endpoint_url" {
  description = "Private service endpoint url"
  value       = ibm_container_vpc_cluster.cluster.private_service_endpoint_url
}

output "public_service_endpoint_url" {
  description = "Public service endpoint url"
  value       = ibm_container_vpc_cluster.cluster.public_service_endpoint_url
}

output "private_albs" {
  description = "List of names, hostnames, and ids for private ALBs"
  value = [
    for load_balancer in ibm_container_vpc_alb.private_alb :
    {
      name     = load_balancer.name
      id       = load_balancer.id
      hostname = load_balancer.load_balancer_hostname
    }
  ]
}

output "public_albs" {
  description = "List of names, hostnames, and ids for public ALBs"
  value = [
    for load_balancer in ibm_container_vpc_alb.public_alb :
    {
      name     = load_balancer.name
      id       = load_balancer.id
      hostname = load_balancer.load_balancer_hostname
    }
  ]
}

##############################################################################