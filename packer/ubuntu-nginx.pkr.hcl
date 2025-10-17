# Переменные вынесены в отдельный файл
variable "folder_id" {
  type    = string
  default = "<идентификатор_каталога>"
}

variable "subnet_id" {
  type    = string
  default = "<идентификатор_подсети>"
}

variable "yc_token" {
  type    = string
  default = "<oauth_токен>"
}

source "yandex" "ubuntu-nginx" {
  token                    = var.yc_token
  folder_id                = var.folder_id
  source_image_family      = "ubuntu-2004-lts"
  ssh_username             = "ubuntu"
  use_ipv4_nat             = "true"
  image_description        = "Custom Ubuntu with Flask app and Nginx"
  image_family             = "ubuntu-2004-lts"
  image_name               = "ubuntu-nginx-flask-{{timestamp}}"
  subnet_id                = var.subnet_id
  disk_type                = "network-ssd"
  zone                     = "ru-central1-a"
}

build {
  sources = ["source.yandex.ubuntu-nginx"]

  # Ansible provisioner вместо shell
  provisioner "ansible" {
    playbook_file = "../ansible/playbook.yml"
    extra_arguments = [
      "--extra-vars", "ansible_python_interpreter=/usr/bin/python3"
    ]
    user = "ubuntu"
  }

  provisioner "shell" {
    inline = [
      "sudo apt-get clean",
      "sudo cloud-init clean",
      "sudo rm -rf /tmp/*"
    ]
  }
}
