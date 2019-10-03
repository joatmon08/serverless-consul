job "nyc311-db-dev" {
  datacenters = ["dc1"]
  type = "service"

  group "nyc311-db-dev" {
    count = 1

    network {
      mode  = "bridge"
    }

    service {
      name = "nyc311-db-dev"
      port = 5432
      tags = ["nyc311", "db", "dev"]

      connect {
        sidecar_service {}
      }
    }
  
    task "postgresql" {
      driver = "docker"

      config {
        image = "joatmon08/nyc311-database"
      }

      env {
        "POSTGRES_USER" = "secret_user"
        "POSTGRES_PASSWORD" = "secret_password"
        "POSTGRES_DB" = "nyc"
      }
    }
  }
}