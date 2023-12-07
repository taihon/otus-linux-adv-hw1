terraform {
  required_providers {
    yandex = {
      source = "yandex-cloud/yandex"
    }
  }
  required_version = ">= 0.13"
}
provider "yandex" {
  zone = "ru-central1-b"
}
data "yandex_compute_image" "last_ubuntu" {
  family = "ubuntu-2204-lts"
}
locals {
  cloudconfig = templatefile("${path.module}/cloudconfig.tftpl", {
    ssh_pubkey = tls_private_key.ansible_ssh_key.public_key_openssh
  })
}
resource "tls_private_key" "ansible_ssh_key" {
  algorithm = "RSA"
  rsa_bits  = 4096
}
resource "yandex_compute_instance" "nginx" {
  name = "nginx"
  resources {
    core_fraction = 5
    cores         = 2
    memory        = 1
  }

  boot_disk {
    initialize_params {
      image_id = data.yandex_compute_image.last_ubuntu.id
    }
  }
  network_interface {
    subnet_id          = yandex_vpc_subnet.public.id
    nat                = true
    security_group_ids = [yandex_vpc_security_group.basic.id]
  }
  scheduling_policy {
    preemptible = true
  }
  metadata = {
    user-data = local.cloudconfig
  }
}
resource "local_file" "idrsapub" {
  filename        = "./id_rsa.pub"
  file_permission = "0633"
  content         = <<-EOT
    ${tls_private_key.ansible_ssh_key.public_key_openssh}
  EOT
}
resource "local_file" "idrsa" {
  filename        = "./id_rsa"
  file_permission = "0600"
  content         = <<-EOT
    ${tls_private_key.ansible_ssh_key.private_key_pem}
  EOT
}
resource "null_resource" "ansible_run_after_all_provisioned" {
  depends_on = [yandex_compute_instance.nginx, local_file.inventory_yml]
  provisioner "local-exec" {
    command = "ansible-playbook ${abspath(path.module)}/playbook.yml"
  }
  triggers = {
    always_run        = "${timestamp()}"
    playbook_src_hash = file("${abspath(path.module)}/playbook.yml")
  }
}
output "nginx_external_ip" {
  value = yandex_compute_instance.nginx.network_interface[0].nat_ip_address
}
