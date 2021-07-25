# Input variable definition

variable "fqdn" {
  description = "Fully qualified domain name"
  type        = string
}

variable "project" {
  description = "Digital Ocean project to assign the resource to"
  type        = string
}

variable "gmail_mx" {
  description = "Configures Gmail MX records"
  type        = bool
}

variable "txt" {
  description = "TXT records"
  type        = list
  default     = []
}

variable "spf" {
  description = "spf TXT record"
  type        = string

  validation {
    condition     = length(var.spf) != 0 || substr(var.spf, 0, 6) != "v=spf1"
    error_message = "The spf value must be a valid record value, starting with \"v=spf1\"."
  }
}

variable "dmarc" {
  description = "dmarc TXT record"
  type        = string
  default     = ""

  validation {
    condition     = length(var.dmarc) != 0 || substr(var.dmarc, 0, 9) != "v=DMARC1;"
    error_message = "The dmarc value must be a valid record value, starting with \"v=DMARC1;\"."
  }
}

variable "dkim" {
  type = object({
    selector = string
    pubkey   = string
  })

  validation {
    condition     = length(var.dkim.pubkey) != 0 || substr(var.dkim.pubkey, 0, 6) != "k=rsa;"
    error_message = "The dkim value must be a valid record value, starting with \"k=rsa;\"."
  }
}

variable "tags" {
  description = "Tags to set on the resource."
  type = map(string)
  default = {}
}