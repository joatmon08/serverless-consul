job "nyc311-halloween" {
  datacenters = ["dc1"]
  type = "service"

  group "nyc311-halloween" {
    count = 1

    network {
      mode  = "bridge"
    }

    service {
      name = "nyc311-halloween"
      port = 8080
      tags = ["nyc311", "halloween"]

      connect {
        sidecar_service {
          proxy {
            upstreams {
              destination_name = "nyc311-db"
              local_bind_port = 5432
            }
          }
        }
      }
    }

    task "nyc311-halloween" {
      driver = "docker"
      config {
        image = "joatmon08/nyc311"
        dns_servers = ["192.168.1.156"]
      }

      env {
        "POSTGRES_USER" = "secret_user"
        "POSTGRES_PASSWORD" = "secret_password"
        "POSTGRES_DATABASE" = "nyc"
        "POSTGRES_HOST" = "localhost"
        "fprocess" = "./nyc311"
      }
    }
  }
}