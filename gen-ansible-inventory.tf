resource "local_file" "inventory_yml" {
  content = templatefile("${path.module}/inventory.tftpl",
    {
      nodes   = yandex_compute_instance.nginx.*
      pubkey  = "${abspath(path.module)}/id_rsa.pub"
      privkey = "${abspath(path.module)}/id_rsa"
  })
  filename = "${abspath(path.module)}/inventory.yml"
}
