#!/bin/bash

set -euf -o pipefail

lego_certs_path=/etc/lego/certificates
lego_cert_path="$lego_certs_path/$DOMAIN.crt"
lego_issuer_cert_path="$lego_certs_path/$DOMAIN.issuer.crt"
lego_key_path="$lego_certs_path/$DOMAIN.key"

syno_certs_path=/usr/syno/etc/certificate/_archive
syno_cert_path="$syno_certs_path/$CERT_IDENTIFIER/cert.pem"
syno_key_path="$syno_certs_path/$CERT_IDENTIFIER/privkey.pem"
syno_chain_path="$syno_certs_path/$CERT_IDENTIFIER/chain.pem"
syno_fullchain_path="$syno_certs_path/$CERT_IDENTIFIER/fullchain.pem"

if [ "$(diff "$lego_cert_path" "$syno_cert_path")" != "" ]; then
  echo "new certificate found"
  cat "$lego_cert_path" "$lego_issuer_cert_path" > "$syno_fullchain_path"
  cp -f "$lego_cert_path" "$syno_cert_path"
  cp -f "$lego_key_path" "$syno_key_path"
  cp -f "$lego_issuer_cert_path" "$syno_chain_path"

  chmod -R 400 "$syno_certs_path/$CERT_IDENTIFIER/"

  echo "restarting services"
  systemctl restart nginx
  systemctl restart pkgctl-WebDAVServer
else
  echo "no new certificate found"
fi
