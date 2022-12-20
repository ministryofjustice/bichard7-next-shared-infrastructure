locals {
  container_count = (
    (var.container_count == null) ?
    length(data.aws_availability_zones.this.zone_ids) : var.container_count
  )
  service_name = var.service_name != null ? var.service_name : var.cluster_name
}
