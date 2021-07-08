# Output variable definitions

output "id" {
  description = "id of the domain"
  value       = digitalocean_domain.default.id
}

output "name" {
  description = "name of the domain"
  value       = digitalocean_domain.default.name
}
