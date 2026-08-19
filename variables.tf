variable "subscription_id" {
  description = "Azure subscription in which the lab is created. Supply through an untracked tfvars file or TF_VAR_subscription_id."
  type        = string
  sensitive   = true

  validation {
    condition     = can(regex("^[0-9a-fA-F-]{36}$", var.subscription_id))
    error_message = "subscription_id must be an Azure subscription GUID."
  }
}

variable "resource_group_name" {
  description = "Name of the new resource group."
  type        = string
  default     = "boundary-multihop-lab"
}

variable "location" {
  description = "Azure region for all cloned resources."
  type        = string
  default     = "japanwest"
}

variable "admin_username" {
  description = "Linux administrator username."
  type        = string
  default     = "azureadmin"
}

variable "admin_source_cidr" {
  description = "Public CIDR allowed to SSH to the standalone bastion VM. Supply through an untracked tfvars file."
  type        = string
  sensitive   = true

  validation {
    condition     = can(cidrhost(var.admin_source_cidr, 0))
    error_message = "admin_source_cidr must be a valid IPv4 or IPv6 CIDR."
  }
}

variable "worker_vnet_cidr" {
  description = "Address space for the worker VNet."
  type        = string

  validation {
    condition     = can(cidrhost(var.worker_vnet_cidr, 0))
    error_message = "worker_vnet_cidr must be a valid CIDR."
  }
}

variable "worker_subnet_cidr" {
  description = "Address prefix for the Boundary worker subnet."
  type        = string

  validation {
    condition     = can(cidrhost(var.worker_subnet_cidr, 0))
    error_message = "worker_subnet_cidr must be a valid CIDR."
  }
}

variable "standalone_bastion_cidr" {
  description = "Address prefix for the standalone jump-host subnet."
  type        = string

  validation {
    condition     = can(cidrhost(var.standalone_bastion_cidr, 0))
    error_message = "standalone_bastion_cidr must be a valid CIDR."
  }
}

variable "target_vnet_cidr" {
  description = "Address space for the target VNet."
  type        = string

  validation {
    condition     = can(cidrhost(var.target_vnet_cidr, 0))
    error_message = "target_vnet_cidr must be a valid CIDR."
  }
}

variable "target_subnet_cidr" {
  description = "Address prefix for the target subnet."
  type        = string

  validation {
    condition     = can(cidrhost(var.target_subnet_cidr, 0))
    error_message = "target_subnet_cidr must be a valid CIDR."
  }
}

variable "hcp_boundary_cidrs" {
  description = "HCP Boundary endpoint CIDRs allowed on worker port 9202. Supply current values through an untracked tfvars file."
  type        = list(string)
  sensitive   = true

  validation {
    condition     = length(var.hcp_boundary_cidrs) > 0 && alltrue([for cidr in var.hcp_boundary_cidrs : can(cidrhost(cidr, 0))])
    error_message = "hcp_boundary_cidrs must contain at least one valid CIDR."
  }
}

variable "image_version" {
  description = "Exact Ubuntu image version observed on all three source VMs."
  type        = string
  default     = "24.04.202608070"
}

variable "enable_boundary_worker_bootstrap" {
  description = "Install and configure Boundary Enterprise on WorkerNode using the referenced GitLab bootstrap. Disabled by default because the source VM has no Azure custom data."
  type        = bool
  default     = false
}

variable "hcp_boundary_cluster_id" {
  description = "HCP Boundary cluster ID. Required only when enable_boundary_worker_bootstrap is true."
  type        = string
  default     = null
  nullable    = true
  sensitive   = true
}

variable "boundary_worker_type_tags" {
  description = "Boundary worker type tags used only when bootstrap is enabled."
  type        = list(string)
  default     = ["azure-intermediate"]
}

variable "tags" {
  description = "Optional tags. The source resource group has no tags, so the default is empty."
  type        = map(string)
  default     = {}
}
