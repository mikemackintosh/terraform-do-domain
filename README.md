# terraform-do-domain
Wraps a Digital Ocean Domain resource, to help simplify managing DNS records.

```tf
module "dns-mikemackintosh-com" {
  source = "https://github.com/mikemackintosh/terraform-do-domain"

  fqdn    = "mikemackintosh.com"
  project = digitalocean_project.mikemackintosh.id

  gmail_mx = true
  spf      = "v=spf1 include:_spf.google.com ~all"
  txt      = [
    "google-site-verification=wzH......."
  ]

  dkim = {
    selector = "google"
    pubkey   = "v=DKIM1; k=rsa; p=MI........
  }

  tags = {
    Environment = "mm"
  }
}
```

You can then extend the DNS output for other resources, such as droplets:

```
resource digitalocean_record "www" {
  domain = module.dns-mikemackintosh-com.name
  name = "www"
  type = "A"
  ttl = 3600
  value = digitalocean_droplet.www.ipv4_address
}

resource digitalocean_record "www-@" {
  domain = module.dns-mikemackintosh-com.name
  name = "@"
  type = "A"
  ttl = 3600
  value = digitalocean_droplet.www.ipv4_address
}
```
