resource "kubernetes_deployment" "mssql" {
  depends_on = [
    helm_release.demo-consul,
  ]

  metadata {
    name = "mssql-deployment"
    labels = {
      app = "mssql"
    }
  }

  spec {
    replicas = 1

    selector {
      match_labels = {
        app = "mssql"
      }
    }

    template {
      metadata {
        labels = {
          app = "mssql"
        }
        annotations = {
          "consul.hashicorp.com/connect-inject"="true"
        }
      }

      spec {
        container {
          image = "kaparora/mssqldb"
          name  = "mssql"
          image_pull_policy = "IfNotPresent"
          port {
            container_port = 1433
          }

          env {
            name = "ACCEPT_EULA"
            value = "Y"
          }
          env {
            name = "SA_PASSWORD"
            value = "Testing!123"
          }
        }
      }
    }
  }
}