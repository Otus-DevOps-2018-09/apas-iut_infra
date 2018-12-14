output "app_external_ip" {
  value = "${module.app.app_external_ip}"
}

output "db_external_ip" {
  value = "${module.db.db_external_ip}"
}

output "vpc_source_ip_ranges" {
  value = "${module.vpc.vpc_source_ranges}"
}
