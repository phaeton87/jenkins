
terraform {
  required_providers {
    yandex = {
      source = "yandex-cloud/yandex"
      version = "0.77.0"
    }
  }
}

provider "yandex" {
  zone = ""
  cloud_id = ""
  folder_id = ""
  token = ""

}