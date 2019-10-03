job "nyc311-halloween-prod" {
  datacenters = ["dc1"]
  type = "service"

  group "nyc311-halloween-prod" {
    count = 1

    network {
      mode  = "bridge"
      port "http" {
         static = 30000
         to     = 8080
      }
    }

    service {
      name = "nyc311-halloween-prod"
      port = 30000
      tags = ["nyc311", "halloween", "prod"]

      connect {
        sidecar_service {
          proxy {
            upstreams {
              destination_name = "nyc311-db-prod"
              local_bind_port = 5432
            }
          }
        }
      }
    }

    task "nyc311-halloween-prod" {
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