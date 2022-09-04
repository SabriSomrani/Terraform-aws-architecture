output "service_account_name" {
  value = kubernetes_service_account.sa_lb_controller.metadata[0].name
}
