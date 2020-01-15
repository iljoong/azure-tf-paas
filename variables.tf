# azure service principal info
variable "subscription_id" {
  default = "add_here"
}

# client_id or app_id
variable "client_id" {
  default = "add_here"
}

variable "client_secret" {
  default = "add_here"
}

# tenant_id or directory_id
variable "tenant_id" {
  default = "add_here"
}

# service variables
variable "prefix" {
  default = "tfdemo"
}

variable "location" {
  default = "koreacentral"
}

variable "tag" {
  default = "demo"
}

# admin username & password for MS SQL
variable "admin_username" {
  default = "azureuser"
}

variable "admin_password" {
  default = "add_here"
}

variable "webapp_template_path" {
  default = "./azwebapp_deploy.json"
}

variable "package_url" {
  default = "https://<add_blobname>.blob.core.windows.net/test/apiapp.zip"
}

# my PC public ip, get it by `curl ipinfo.io`
variable "local_ip" {
  default = "_add_here_"
}

# select deploy method zipdeploy = `true`, arm template deply = `false`
# TF if-statement: https://blog.gruntwork.io/terraform-tips-tricks-loops-if-statements-and-gotchas-f739bbae55f9
variable "zipdeploy" {
  default = true
}

variable "windows" {
  default = true
}