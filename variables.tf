variable "sg_ip_address" {
  description = "The IP address to allow in the security group"
  type        = string
  default     = "0.0.0.0/0"
}

variable "public_key_path" {
  description = "Path to the public key file for the key pair"
  type        = string
  default     = "~/.ssh/dev_key.pub"
}