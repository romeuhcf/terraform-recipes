# -- Production
# variable "demo_acme_server_url"          { default = "https://acme.api.letsencrypt.org/directory"}
# variable "demo_acme_registration_email"  { default = "your-email@your-company.com" }
# -- Staging
variable "acme_server_url" { default = "https://acme-staging-v02.api.letsencrypt.org/directory" }
variable "acme_registration_email" { default = "john@example.com" }
variable "common_name_domain_prefix" { default = "www." }
variable "AWS_ACCESS_KEY" {}
variable "AWS_SECRET_KEY" {}
variable "AWS_REGION" {
  default = "us-east-1"
}
variable "instance_type" {
  default = "t2.micro"
}
variable "app_name" {
  default = "myapp"
}
variable "AMIS" {
  type = "map"
  default = {
    us-east-1 = "ami-079f96ce4a4a7e1c7"
    us-west-2 = "ami-0475f60cdd8fd2120"
  }
}

variable "PATH_TO_PRIVATE_KEY" {
  default = "mykeys"
}
variable "PATH_TO_PUBLIC_KEY" {
  default = "mykeys.pub"
}
variable "INSTANCE_USERNAME" {
  default = "ubuntu"
}
