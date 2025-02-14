variable "tags" {
  description = "Additional tags for the resource"
  type        = map(string)
}

variable "project" {
  description = "Project name"
  type        = string
}

variable "environment" {
  description = "Environment name"
  type        = string
}

variable "region" {
  description = "AWS region to deploy the resources"
  type        = string
}

variable "kms_vars" {
  description = "KMS key configuration"
  type        = map(any)
}

variable "aliases" {
  description = "List of aliases to assign to the KMS key (e.g., [\"alias/my-key\"])"
  type        = list(string)
}

variable "key_owners" {
  description = "List of IAM principal ARNs that will have full control over the key"
  type        = list(string)
}

variable "key_admins" {
  description = "List of IAM principal ARNs that can administer the key (e.g., modify key settings)"
  type        = list(string)
}

variable "key_users" {
  description = "List of IAM principal ARNs that are allowed to use the key for encryption/decryption"
  type        = list(string)
}
