variable "roles" {
  type = list(object({
    name     = string
    policies = list(string)
  }))
}

variable "groups" {
  type = list(object({
    name     = string
    policies = list(string)
  }))
}
