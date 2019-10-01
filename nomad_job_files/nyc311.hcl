job "nyc311-halloween" {
  datacenters = ["dc1"]
  type = "service"

  group "nyc311-halloween" {
    count = 1
    task "nyc311-halloween" {
      driver = "docker"
      config {
        image = "joatmon08/nyc311"

        dns_servers = ["192.168.1.156"]

        port_map {
          http = 8080
        }
      }

      env {
        "POSTGRES_USER" = "secret_user"
        "POSTGRES_PASSWORD" = "secret_password"
        "POSTGRES_DATABASE" = "nyc"
        "POSTGRES_HOST" = "nyc311-db.service.consul"
        "fprocess" = "./handler"
      }

      resources {
        cpu = 100
        memory = 128
        network {
          port "http" {}
        }
      }

      service {
        name = "nyc311-halloween"
        port = "http"
        tags = ["nyc311", "halloween"]
      }
    }
  }
}