terraform {
  required_providers {
    digitalocean = {
      source  = "digitalocean/digitalocean"
      version = "2.8.0"
    }
  }
}

resource "digitalocean_domain" "default" {
  name = var.fqdn
}

resource "digitalocean_record" "google-verification" {
  count  = length(var.txt)
  domain = digitalocean_domain.default.name
  type   = "TXT"
  name   = "@"
  value  = var.txt[count.index]
}

resource "digitalocean_record" "spf" {
  domain = digitalocean_domain.default.name
  type   = "TXT"
  name   = "@"
  value  = var.spf
  count  = length(var.spf) > 0 ? 1 : 0
}

resource "digitalocean_record" "dkim" {
  for_each = var.dkim
  domain   = digitalocean_domain.default.name
  type     = each.value.type
  name     = "${each.key}._domainkey"
  value    = each.value.pubkey
}

resource "digitalocean_record" "dmarc" {
  domain = digitalocean_domain.default.name
  type   = "TXT"
  name   = "_dmarc"
  value  = var.dmarc
  count  = length(var.dmarc) > 0 ? 1 : 0
}

locals {
  gmail_mx_records = {
    "skip" = {}
    "default" = {
      "aspmx.l.google.com."      = { "priority" = 1, "ttl" = 1800 },
      "alt1.aspmx.l.google.com." = { "priority" = 5, "ttl" = 1800 },
      "alt2.aspmx.l.google.com." = { "priority" = 5, "ttl" = 1800 },
      "alt3.aspmx.l.google.com." = { "priority" = 10, "ttl" = 1800 },
      "alt4.aspmx.l.google.com." = { "priority" = 10, "ttl" = 1800 },
    }
  }
}

resource "digitalocean_record" "gmail_mx_map" {
  for_each = local.gmail_mx_records[var.gmail_mx ? "default" : "skip"]

  name     = "@"
  type     = "MX"
  domain   = digitalocean_domain.default.id
  value    = each.key
  priority = each.value.priority
  ttl      = each.value.ttl
}

resource "digitalocean_project_resources" "default" {
  project = var.project
  resources = [
    digitalocean_domain.default.urn
  ]
}
