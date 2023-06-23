variable "do_token" {
  type          = string
  sensitive     = true
  description   = "Digital Ocean API Key"
}

variable "pvt_key" {

}

data "digitalocean_ssh_key" "terraform" {
  name = "dop_v1_8c7bfdb97f5cd3fce07f57363f96a5df9b4056fe3b9e74bbb328dff649dad48b"
}