#!/bin/sh

COUNTRY=TN
STATE=TN
LOCALITY=TN
ORGANIZATION=INSAT
ORGANIZATIONUNIT=IT
COMMONNAME=mosquitto

cd certs

# Generate the fake certificate authority's (CA) signing key

openssl genrsa -out ca.key 2048 
# Generate a certificate signing request for the fake CA
openssl req -new -key ca.key -out ca.csr -sha256 \
    -subj "/C=$COUNTRY/ST=$STATE/L=$LOCALITY/O=$ORGANIZATION/OU=$ORGANIZATIONUNIT/CN=random/"
# Create the fake CA's root certificate 
openssl x509 -req -in ca.csr -signkey ca.key -out ca.crt -days 365 -sha256
# Create the server / mqtt broker's keypair
openssl genrsa -out server.key 2048
# Create a certificate signing request using the server key to send to the fake CA for identity verification
openssl req -new -key server.key -out server.csr -sha256 \
    -subj "/C=$COUNTRY/ST=$STATE/L=$LOCALITY/O=$ORGANIZATION/OU=$ORGANIZATIONUNIT/CN=$COMMONNAME/"

openssl x509 -req -in server.csr -CA ca.crt -CAkey ca.key -CAcreateserial -out server.crt -days 360
