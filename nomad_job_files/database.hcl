job "nyc311" {
  datacenters = ["dc1"]
  type = "service"

  group "database" {
    count = 1
    task "postgresql" {
      driver = "docker"
      config {
        image = "joatmon08/nyc311-database"

        port_map {
          http = 5432
        }
      }

      env {
        "POSTGRES_USER" = "secret_user"
        "POSTGRES_PASSWORD" = "secret_password"
        "POSTGRES_DB" = "nyc"
      }

      resources {
        network {
          port "http" {
            static = 5432
          }
        }
      }

      service {
        port = "http"

        check {
          type     = "script"
          name     = "check_table"
          command  = "/bin/bash"
          args     = ["-c", "psql -w -U ${POSTGRES_USER} ${POSTGRES_DB} -c SELECT"]
          interval = "60s"
          timeout  = "2s"

          check_restart {
            limit = 3
            grace = "90s"
            ignore_warnings = false
          }
        }
      }
    }
  }
}