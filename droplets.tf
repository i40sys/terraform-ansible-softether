resource "digitalocean_droplet" "test" {
  count  = 1
  image  = "ubuntu-20-04-x64"
  name   = "test-${count.index}"
  region = "fra1"
  size   = "s-1vcpu-1gb"

  ssh_keys = [
      data.digitalocean_ssh_key.terraform.id
  ]

  provisioner "remote-exec" {
    inline = ["sudo apt update", "sudo apt install python3 -y", "echo Done!"]

    connection {
      host        = self.ipv4_address
      type        = "ssh"
      user        = "root"
      private_key = file(var.pvt_key)
    }
  }

  provisioner "local-exec" {
    command = "ANSIBLE_HOST_KEY_CHECKING=False ansible-playbook -u root -i '${self.ipv4_address},' --private-key '${var.pvt_key}' -e 'pub_key=${var.pub_key}' playbooks/updating-system.yml playbooks/installing-docker.yml playbooks/installing-softether-vpnclient.yml"
  } 
}

output "droplet_ip_addresses" {
  value = {
    for droplet in digitalocean_droplet.test:
    droplet.name => droplet.ipv4_address
  }
}