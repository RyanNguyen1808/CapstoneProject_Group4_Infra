variable "cards_table_name" {
  type        = string
  default     = "cards"
  description = "Table Name for Cards"
}

variable "name_prefix" {
  type        = string
  default     = "ce11-capstone-group4"
  description = "Prefix for Resources"
}

variable "dev_callback_url" {
  type        = string
  default     = "http://localhost:4200/callback"
  description = "Development App Callback URL"
}

variable "prod_callback_url" {
  type        = string
  default     = "https://yourdomain.com/callback"
  description = "Production App Callback URL"
}

variable "dev_logout_url" {
  type        = string
  default     = "http://localhost:4200/logout"
  description = "Development App Logout URL"
}

variable "prod_logout_url" {
  type        = string
  default     = "https://yourdomain.com/logout"
  description = "Production App Logout URL"
}

variable "cognito_auth_domain" {
  type        = string
  default     = "ce11-capstone-group4"
  description = "Cognito Auth Domain"
}

variable "region" {
  type        = string
  default     = "us-east-1"
  description = "Region"
}

variable "domain" {
  type        = string
  description = "Domain used for Capstone Project"
  default     = "sctp-sandbox.com"
}

variable "bucket_name" {
  type        = string
  description = "Bucket for hosting the Web App Frontend"
  default     = "frontendwebapp"
}

variable "allowed_origin" {
  type        = string
  description = "Frontend origin allowed to access API"
}