storage "file" {
  path = "vault-data"
}

listener "tcp" {
  tls_disable = "true"
}

disable_mlock = true
