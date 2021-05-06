variable "org" {
  default = "test"
}

variable "space" {
  default = "test"
}

variable "region" {
  default = "test"
}

variable "iam_region" {
  default = "test"
}

variable "ibm_id1" {
  default = "test"
}

variable "datacenter" {
  default = "test"
}

variable "machine_type" {
  default = "test"
}

variable "isolation" {
  default = "test"
}

variable "private_vlan_id" {
  default = "test"
}

variable "public_vlan_id" {
  default = "test"
}

variable "cluster_name" {
  default = "cluster"
}

variable "service_name" {
  default = "IBM Bluemix Container Service"
}

variable "ibmcloud_apikey" {
  description = "Enter your IBM Cloud API Key, you can get your IBM Cloud API key using: https://cloud.ibm.com/iam#/apikeys"
} 

variable "resource_group_id" {
  description = "Enter your IBM resource group ID"
}