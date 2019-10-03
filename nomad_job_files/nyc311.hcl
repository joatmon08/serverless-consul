job "nyc311-halloween" {
  datacenters = ["dc1"]
  type = "service"

  group "nyc311-halloween" {
    count = 1

    network {
      mode  = "bridge"
      port "http" {
         static = 8080
         to     = 8080
      }
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
      }

      env {
        "POSTGRES_USER" = "secret_user"
        "POSTGRES_PASSWORD" = "secret_password"
        "POSTGRES_DATABASE" = "nyc"
        "POSTGRES_HOST" = "127.0.0.1"
        "fprocess" = "./handler"
      }
    }
  }
}