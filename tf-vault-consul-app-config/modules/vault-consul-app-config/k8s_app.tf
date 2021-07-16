resource "kubernetes_deployment" "app" {
  depends_on = [
    vault_kubernetes_auth_backend_role.myrole,
    vault_database_secret_backend_role.dotnet-app,
    vault_database_secret_backend_connection.mssql
  ]
  wait_for_rollout = "false"
  metadata {
    name = "app-deployment"
    labels = {
      app = "app"
    }
  }

  spec {
    replicas = 1
    selector {
      match_labels = {
        app = "app"
      }
    }

    template {
      metadata {
        labels = {
          app = "app"
        }
        annotations = {
          "consul.hashicorp.com/connect-inject"="true",
          "consul.hashicorp.com/connect-service-upstreams"="mssql:1433, consul:8500",
          "vault.hashicorp.com/log-level"="debug",
          "vault.hashicorp.com/agent-inject"="true",
          "vault.hashicorp.com/agent-inject-status"="update",
          "vault.hashicorp.com/agent-inject-token"="true",
          "vault.hashicorp.com/secret-volume-path"="/app/vault",
          "vault.hashicorp.com/agent-init-first"="true",
          "vault.hashicorp.com/role"="myrole"
        }
      }

      spec {
        volume {
          name = "app-config"
          empty_dir {

          } 
        }
        volume {
          name = "appsettings"
          config_map {
            name = "appsettings"
            items {
              key = "appsettings.json.ctmpl"
              path = "appsettings.json.ctmpl"
            }

          } 
        }
        service_account_name = "app"
        termination_grace_period_seconds = 90
        container {
          image = "kaparora/projectapi:v2"
          name  = "app"
          image_pull_policy = "IfNotPresent"
          port {
            container_port = 80
          }
          volume_mount {
            name      = "app-config"
            mount_path = "/app/config"
          }
          volume_mount {
            name      = "appsettings"
            mount_path = "/app/template"
          }
        }
        container {
          image = "hashicorp/consul-template:alpine"
          name  = "consul-template"
          image_pull_policy = "IfNotPresent"
          env {
            name = "CONSUL_HTTP_ADDR"
            value = "http://consul-consul-server:8500"
          }
          env {
            name = "VAULT_ADDR"
            value = "http://vault:8200"
          }
          command = ["/bin/sh"]
          args = ["-c", "consul-template -vault-addr=$VAULT_ADDR -vault-agent-token-file=\"/app/vault/token\" -template \"/app/template/appsettings.json.ctmpl:/app/config/appsettings.json\" -log-level=debug"]
          volume_mount {
            name      = "app-config"
            mount_path = "/app/config"
          }
          volume_mount {
            name      = "appsettings"
            mount_path = "/app/template"
          }
        }
        init_container {
          image = "hashicorp/consul-template:alpine"
          name  = "consul-template-init"
          image_pull_policy = "IfNotPresent"
          env {
            name = "CONSUL_HTTP_ADDR"
            value = "http://consul-consul-server:8500"
          }
          env {
            name = "VAULT_ADDR"
            value = "http://vault:8200"
          }
          command = ["/bin/sh"]
          args = ["-c", "consul-template -vault-addr=$VAULT_ADDR -vault-agent-token-file=\"/app/vault/token\" -template \"/app/template/appsettings.json.ctmpl:/app/config/appsettings.json\" -log-level=debug --once"]
          volume_mount {
            name      = "app-config"
            mount_path = "/app/config"
          }
          volume_mount {
            name      = "appsettings"
            mount_path = "/app/template"
          }
        }
      }
    }
  }
}

resource "kubernetes_config_map" "appsettings" {
  metadata {
    name = "appsettings"
  }

  data = {
    "appsettings.json.ctmpl" = "${file("${path.module}/appsettings.json.ctmpl")}"
  }
}


resource "kubernetes_service" "app" {
  wait_for_load_balancer  = "true"
  metadata {
    name = "app"
  }
  spec {
    selector = {
      app = "app"
    }
    port {
      port        = 80
      target_port = 80
    }

    type = "LoadBalancer"
  }
}