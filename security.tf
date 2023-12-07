resource "yandex_vpc_network" "my-vpc" {

}
resource "yandex_vpc_subnet" "public" {
  name           = "mysubnet"
  zone           = "ru-central1-b"
  network_id     = yandex_vpc_network.my-vpc.id
  v4_cidr_blocks = ["192.168.1.0/24"]
}

resource "yandex_vpc_security_group" "basic" {
  name       = "basic rules"
  network_id = yandex_vpc_network.my-vpc.id
  ingress {
    protocol       = "TCP"
    v4_cidr_blocks = ["0.0.0.0/0"]
    port           = 80
  }
  ingress {
    protocol       = "TCP"
    v4_cidr_blocks = ["0.0.0.0/0"]
    port           = 443
  }
  ingress {
    protocol       = "TCP"
    v4_cidr_blocks = ["0.0.0.0/0"]
    port           = 22
  }
  egress {
    protocol       = "TCP"
    v4_cidr_blocks = ["0.0.0.0/0"]
    from_port      = 0
    to_port        = 65535
  }
}
