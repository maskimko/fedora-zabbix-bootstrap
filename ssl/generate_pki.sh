#!/bin/bash
mkdir -p ca/root-ca/private ca/root-ca/db crl certs
chmod 700 ca/root-ca/private
cp /dev/null ca/root-ca/db/root-ca.db
cp /dev/null ca/root-ca/db/root-ca.db.attr
echo 01 > ca/root-ca/db/root-ca.crt.srl
echo 01 > ca/root-ca/db/root-ca.crl.srl
openssl req -new -config root_ca.conf -out ca/root_ca.csr -keyout ca/root-ca/private/root-ca.key
openssl ca -selfsign -config root_ca.conf  -in ca/root_ca.csr -out ca/root-ca.crt -extensions root_ca_ext 
mkdir -p ca/signing-ca/private ca/signing-ca/db crl certs
chmod 700 ca/signing-ca/private
cp /dev/null ca/signing-ca/db/signing-ca.db
cp /dev/null ca/signing-ca/db/signing-ca.db.attr
echo 01 > ca/signing-ca/db/signing-ca.crt.srl
echo 01 > ca/signing-ca/db/signing-ca.crl.srl
openssl req  -new -config signing_ca.conf  -out ca/signing-ca.csr -keyout ca/signing-ca/private/signing-ca.key
openssl ca -config root_ca.conf -in ca/signing-ca.csr -out ca/signing-ca.crt -extensions signing_ca_ext 
openssl req -new -config email_req.conf -out certs/user-email.csr -keyout certs/user-email.key
openssl ca -config signing_ca.conf  -in certs/user-email.csr -out certs/user-email.crt -extensions email_ext 

