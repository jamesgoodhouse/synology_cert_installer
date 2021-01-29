#!/bin/bash

set -euf -o pipefail

lego_certs_path=/etc/lego/certificates
syno_certs_path=/usr/syno/etc/certificate/_archive

cat "$lego_certs_path/$DOMAIN.crt" "$lego_certs_path/$DOMAIN.issuer.crt" > "$syno_certs_path/$CERT_IDENTIFIER/fullchain.pem"
cp -f "$lego_certs_path/$DOMAIN.crt" "$syno_certs_path/$CERT_IDENTIFIER/cert.pem"
cp -f "$lego_certs_path/$DOMAIN.key" "$syno_certs_path/$CERT_IDENTIFIER/privkey.pem"
cp -f "$lego_certs_path/$DOMAIN.issuer.crt" "$syno_certs_path/$CERT_IDENTIFIER/chain.pem"

chmod -R 400 "$syno_certs_path/$CERT_IDENTIFIER/"

synoservice --restart nginx
