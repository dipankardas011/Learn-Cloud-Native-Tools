# Full configuration options can be found at https://www.vaultproject.io/docs/configuration

ui = true

#mlock = true
#disable_mlock = true

disable_mlock = true
#storage "file" {
#  path = "/home/dipankar/vault/data"
#}

storage "s3" {
  bucket = "2qedew3fwe3fwcfwe"
}

#storage "consul" {
#  address = "127.0.0.1:8500"
#  path    = "vault"
#}

# HTTP listener
#listener "tcp" {
#  address = "127.0.0.1:8200"
#  tls_disable = 1
#}

# HTTPS listener
listener "tcp" {
  address       = "0.0.0.0:8200"
  tls_disable = 1
  tls_cert_file = "/etc/vault.d/vault.crt"
  tls_key_file  = "/etc/vault.d/vault.key"
  tls_disable_client_certs = "true"
}

# Enterprise license_path
# This will be required for enterprise as of v1.8
#license_path = "/etc/vault.d/vault.hclic"

# Example AWS KMS auto unseal
seal "awskms" {
  region = "us-ea2qw2edwq"
  kms_key_id = "dsedsdse"
  endpoint = "kms.us-east-1.amazonaws.com"
}

# Example HSM auto unseal
#seal "pkcs11" {
#  lib            = "/usr/vault/lib/libCryptoki2_64.so"
#  slot           = "0"
#  pin            = "AAAA-BBBB-CCCC-DDDD"
#  key_label      = "vault-hsm-key"
#  hmac_key_label = "vault-hsm-hmac-key"
#}
