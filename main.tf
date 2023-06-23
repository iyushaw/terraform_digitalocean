resource "digitalocean_tag" "project_tag" {
    name    = "hackerops"
}

resource "digitalocean_ssh_key" "ssh_key" {
    name        = "Dev SSH Key"
    public_key  = "/home/pipi/.ssh/id_ed25519.pub"
}

resource "digitalocean_droplet" "hackerops_vm_1" {
    image = "ubuntu-22-04-x64"
    name = "hackerops-vm"
    region = "nyc1"
    size = "s-2vcpu-2gb-amd"
    tags = [digitalocean_tag.project_tag.id]
    private_networking = true
    ssh_key = [
        digitalocean_ssh_key.ssh_key.fingerprint
    ]

    connection {
        host = self.ipv4_address
        user = "root"
        type = "ssh"
        agent = "false"
        timeout = "3m"
        private_key = file("/home/pipi/.ssh/id_ed25519.pub")
    }

    provisioner "remote-exec" {
        inline = [
            "export PATH=$PATH:/usr/bin",
            "sudo apt update",
            "sudo adduser --disable-password --gecos '' ansible",
            "sudo mkdir -p /home/ansible/.ssh",
            "sudo touch /home/ansible/.ssh/authorized_keys",
            "sudo echo '${file("/home/pipi/.ssh/id_ed25519.pub")}' > authorized_keys",
            "sudo mv authorized_keys /home/ansible/.ssh",
            "sudo chown -R ansible:ansible /home/ansible.ssh",
            "sudo chmod 700 /home/ansible/.ssh",
            "sudo chmod 600 /home/ansible/.ssh/authorized_keys",
            "sudo usermod -aG sudo ansible",
            "sudo echo 'ansible ALL=(ALL) NOPASSWD:ALL' | sudo tee -a /etc/sudoers",
            "sudo apt update"
        ]
    }
}

resource "digitalocean_firewall" "firewall"{
    name = "hackerops-firewall"

    droplet_id = [digitalocean_droplet.hackerops_vm_1.id]

    inbound_rule {
        protocol = "tcp"
        port_range = "22"
        source_addresses = ["0.0.0.0/0"]

    }

    inbound_rule {
        protocol = "tcp"
        port_range = "80"
        source_addresses = ["0.0.0.0/0"]
    }

    inbound_rule {
        protocol = "tcp"
        port_range = "443"
        source_addresses = ["0.0.0.0/0"]
    }

    outbound_rule {
        protocol = "tcp"
        port_range = "1-65535"
        destination_addresses = ["0.0.0.0/0"]
    }

    outbound_rule {
        protocol = "udp"
        port_range = "1-65535"
        destination_addresses = ["0.0.0.0/0"]
    }
}