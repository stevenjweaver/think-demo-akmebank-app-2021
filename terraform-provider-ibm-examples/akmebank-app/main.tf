# ibm provider + account key (identifier and pass)
provider "ibm"{
  ibmcloud_api_key = "${var.ibmcloud_apikey}"
  region = "us-east"
} 
    
#+++++++++++++++++++++++++++++++++++++++++++++++++++
# provision infrastructure resources: logdnaAT , KMS, IAM
#+++++++++++++++++++++++++++++++++++++++++++++++++++

#****************************************************
#logdnaAT
#*****************************************************
# remove this service to trigger an alert


#*********************************************
#KMS
#*********************************************
resource "ibm_resource_instance" "kp_instance" {
  name     = "demo_KMS_instance"
  service  = "kms"
  plan     = "tiered-pricing" 
  location = "us-east"
  resource_group_id = "${var.resource_group_id}"
  tags     = ["dev","think2020"]
}

resource "ibm_kp_key" "cos_encrypt" {
  key_protect_id  = "${ibm_resource_instance.kp_instance.guid}"
  key_name     = "key-name"
  standard_key = false
}

#*****************************************
# setup IAM
#*****************************************

#auth policy for cos to read kms keys
resource "ibm_iam_authorization_policy" "policy" {
  source_service_name         = "cloud-object-storage"
  target_service_name         = "kms"
  roles                       = ["Reader"]
}


#-------------------
#service id
resource "ibm_iam_service_id" "serviceID" {
  name = "demo-cis-dervice"
}

resource "ibm_iam_service_policy" "policy" {
  iam_service_id = "${ibm_iam_service_id.serviceID.id}"
  roles        = ["Writer"]

  resources { # remove this block to trigger an alert
    service = "cloud-object-storage"
    resource_group_id = "${var.resource_group_id}" # remove this line to trigger an alert
  }
}

#*****************************************
#provision COS
#*****************************************

resource "ibm_resource_instance" "cos_instance" {
  name              = "demo_cos_instance"
  resource_group_id = "${var.resource_group_id}"
  service           = "cloud-object-storage"
  plan              = "standard"
  location          = "global"
  tags              = ["dev","think2020"]
}

resource "ibm_cos_bucket" "standard-ams03" {
  bucket_name          = "demo-cos-instance-think2020-accounts"
  resource_instance_id = "${ibm_resource_instance.cos_instance.id}"
  region_location      = "us-east"
  storage_class        = "standard"
  key_protect          = "${ibm_kp_key.cos_encrypt.id}" #remove this line to trigger an alert
}

resource "ibm_cos_bucket" "standard-ams04" {
  bucket_name          = "demo-cos-instance-think2020-users"
  resource_instance_id = "${ibm_resource_instance.cos_instance.id}"
  region_location      = "us-east"
  storage_class        = "standard"
  key_protect          = "${ibm_kp_key.cos_encrypt.id}" #remove this line to trigger an alert
}

resource "ibm_cos_bucket" "standard-ams05" {
  bucket_name          = "demo-cos-instance-think2020-users-unencrypted"
  resource_instance_id = "${ibm_resource_instance.cos_instance.id}"
  region_location      = "us-east"
  storage_class        = "standard"
  #key_protect          = "${ibm_kp_key.cos_encrypt.id}" #remove this line to trigger an alert
}


#****************************************
#provision CIS
#*****************************************

resource "ibm_cis" "demo_web_domain" {
  name              = "web_domain"
  resource_group_id = "${var.resource_group_id}"
  plan              = "standard"
  location          = "global"
  tags              = ["dev","think2020"]
}

resource "ibm_cis_domain_settings" "demo_web_domain" {
  cis_id          = "${ibm_cis.demo_web_domain.id}"
  domain_id       = "${ibm_cis_domain.demo_web_domain.id}"
  waf             = "off" #set this off to trigger an alert
  ssl             = "full"
  min_tls_version = "1.2"
}

resource "ibm_cis_domain" "demo_web_domain" {
  cis_id = "${ibm_cis.demo_web_domain.id}"
  domain = "demo.ibm.com"
}

resource "ibm_cis_origin_pool" "example" {
  cis_id = "${ibm_cis.demo_web_domain.id}"
  name = "example-pool"
  origins {
    name = "example-1"
    address = "192.0.2.1"
    enabled = false
  }
  origins {
    name = "example-2"
    address = "192.0.2.2"
    enabled = false
  }
  description = "example load balancer pool"
  enabled = false
  minimum_origins = 1
  notification_email = "someone@example.com"
  check_regions      = [ "ENAM"]
}

# remove this resource to trigger an alert
resource "ibm_cis_global_load_balancer" "example_glb" {
    cis_id = "${ibm_cis.demo_web_domain.id}"
    domain_id = "${ibm_cis_domain.demo_web_domain.id}"
    name = "demo.ibm.com"
    fallback_pool_id = "${ibm_cis_origin_pool.example.id}"
    default_pool_ids = ["${ibm_cis_origin_pool.example.id}"]
    description = "example load balancer using geo-balancing"
    proxied = true # set this to false or remove property to trigger an alert
}

