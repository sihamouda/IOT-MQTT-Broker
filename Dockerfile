FROM alpine/openssl as tls-generator

ARG COUNTRY=TN
ARG STATE=TN
ARG LOCALITY=TN
ARG ORGANIZATION=INSAT
ARG ORGANIZATIONUNIT=IT
ARG COMMONNAME=mosquitto

WORKDIR /certs

# Create a key pair for the CA
RUN openssl genrsa -out ca.key 2048 
# Create a certificate for the CA using the CA key
RUN openssl req -new -x509 -days 1826 -key ca.key -out ca.crt \
    -subj "/C=${COUNTRY}/ST=${STATE}/L=${LOCALITY}/O=${ORGANIZATION}/OU=${ORGANIZATIONUNIT}/CN=${COMMONNAME}/"
# Create a server key pair that will be used by the broker
RUN openssl genrsa -out server.key 2048
# Create a certificate request
RUN openssl req -new -out server.csr -key server.key \
    -subj "/C=${COUNTRY}/ST=${STATE}/L=${LOCALITY}/O=${ORGANIZATION}/OU=${ORGANIZATIONUNIT}/CN=${COMMONNAME}/"
# Verify and sign the server certificate
RUN openssl x509 -req -in server.csr -CA ca.crt -CAkey ca.key -CAcreateserial -out server.crt -days 360

FROM eclipse-mosquitto:2 as mosquitto-base

ARG UID
ARG GID
ARG USER

ARG AUTH_METHOD=false
ARG AUTH_USER
ARG AUTH_PASSWORD
ARG TLS=false

COPY config/mosquitto.conf /mosquitto/config/mosquitto.conf
COPY bin/entrypoint.sh /mosquitto/entrypoint.sh

COPY --from=tls-generator /certs/ca.crt /mosquitto/certs/ca.crt
COPY --from=tls-generator /certs/server.crt /mosquitto/certs/server.crt
COPY --from=tls-generator /certs/server.key /mosquitto/certs/server.key

RUN /mosquitto/entrypoint.sh -a ${AUTH_METHOD} -u ${AUTH_USER} -p ${AUTH_PASSWORD} -s ${TLS}

CMD /usr/sbin/mosquitto --verbose -c /mosquitto/config/mosquitto.conf
