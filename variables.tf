variable "do_token" {
  type          = string
  sensitive     = true
  description   = "Digital Ocean API Key"
}

variable "pvt_key" {

}

data "digitalocean_ssh_key" "terraform" {
  name = ""
}