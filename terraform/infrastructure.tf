data "yandex_compute_image" "ubuntu_image" {
  family = "ubuntu-2004-lts"
}

resource "yandex_compute_instance" "build" {        
    name        = "build"  
    zone        = "ru-central1-a"

    resources {
        cores   = 2                                            
        memory  = 2                                           
    }

    boot_disk {
        initialize_params {
            image_id = data.yandex_compute_image.ubuntu_image.id
            size     = 15
        }
    }

    network_interface {
        subnet_id   = yandex_vpc_subnet.subnet-1.id
        ip_address  = "192.168.150.101"
        nat         = true
    }

    scheduling_policy {
      preemptible = true
    }

    metadata = {
        ssh-keys = "ubuntu:${file("~/.ssh/id_rsa.pub")}"
    }
}

resource "yandex_compute_instance" "prod" {
    name        = "prod"  
    zone        = "ru-central1-a"

    resources {
        cores   = 2                                            
        memory  = 2                                           
    }

    boot_disk {
        initialize_params {
            image_id = data.yandex_compute_image.ubuntu_image.id
            size     = 15
        }
    }

    network_interface {
        subnet_id   = yandex_vpc_subnet.subnet-1.id
        ip_address  = "192.168.150.100"
        nat         = true
    }

    scheduling_policy {
      preemptible = true
    }

    metadata = {
        ssh-keys = "ubuntu:${file("~/.ssh/id_rsa.pub")}"
    }
}

resource "yandex_vpc_network" "network-1" {
  name = "network1"
}

resource "yandex_vpc_subnet" "subnet-1" {
  name           = "subnet1"
  zone           = "ru-central1-a"
  network_id     = yandex_vpc_network.network-1.id
  v4_cidr_blocks = ["192.168.150.0/24"]
}

data "template_file" "inventory" {
    template = file("./_templates/inventory.tpl")
  
    vars = {
        user = "ubuntu"
        host-1 = join("", [yandex_compute_instance.prod.network_interface.0.nat_ip_address])
        host-2 = join("", [yandex_compute_instance.build.network_interface.0.nat_ip_address])
    }
}

resource "local_file" "save_inventory" {
   content  = data.template_file.inventory.rendered
   filename = "../ansible/inventory"
}
