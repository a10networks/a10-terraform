
resource "kubernetes_deployment" "example_deployment" {
  metadata {
    name = "cthunder"
    labels = {
      test = "cthunder"
    }
  }

  spec {
    replicas = 1

    selector {
      match_labels = {
        test = "cthunder"
      }
    }

    template {
      metadata {
        labels = {
          test = "cthunder"
        }
        annotations = {
          "k8s.v1.cni.cncf.io/networks" = "server-bridge"
        }
      }

      spec {
        container {
          name              = "cthunder"
          image             = "acos_docker_5_2_0_155:latest"
          image_pull_policy = "Never"
          env {
            name  = "ACOS_CTH_SUPPORT_MGMT"
            value = "y"
          }
          env {
            name  = "ACOS_CTH_SUPPORT_VETH"
            value = "y"
          }
          env {
            name  = "ACOS_CTH_VETH_DRIVER_LST"
            value = "macvlan,veth"
          }
          resources {
            requests {
              memory = "4Gi"
              cpu    = "4"
            }
            limits {
              memory = "4Gi"
              cpu    = "4"
            }
          }
          port {
            container_port = 80
          }
          security_context {
            privileged  = true
            run_as_user = 0
            capabilities {
              add = [
                "SYS_ADMIN",
                "NET_ADMIN",
                "IPC_LOCK"
              ]
            }
          }
        }
      }
    }
  }
}
