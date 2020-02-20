#!/bin/bash

# +-------------------------------------------------
# | OpenSSL Helper
# +-------------------------------------------------

function openssl-print-certs()
{
  openssl crl2pkcs7 -nocrl -certfile "${1}" | openssl pkcs7 -print_certs -text -noout
}

function openssl-fingerprint-cert()
{
  openssl x509 -noout -in "${1}" -fingerprint -md5
  openssl x509 -noout -in "${1}" -fingerprint -sha1
  openssl x509 -noout -in "${1}" -fingerprint -sha256
}

function openssl-fingerprint-pkey()
{
  local pkey=$(mktemp)

  openssl x509 -noout -in "${1}" -pubkey | openssl pkey -pubin -outform DER > $pkey

  cat $pkey | openssl dgst -md5 -binary | echo "MD5 Fingerprint=$(hexdump -ve '/1 "%02X:"')"
  cat $pkey | openssl dgst -sha1 -binary | echo "SHA1 Fingerprint=$(hexdump -ve '/1 "%02X:"')"
  cat $pkey | openssl dgst -sha256 -binary | echo "SHA256 Fingerprint=$(hexdump -ve '/1 "%02X:"')"

  rm $pkey
}

