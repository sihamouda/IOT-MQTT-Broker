# Simple Mosquitto broker

![Mosquitto Logo](https://mosquitto.org/images/mosquitto-text-side-28.png 'Mosquitto')

This is a simple [Mosquitto](https://mosquitto.org) broker to quickly initialize projects requiring an MQTT broker.

## Prerequisite

- [Docker](https://www.docker.com/)
- [Docker Compose V2](https://docs.docker.com/compose/)

## How to use

For development purposes, you need to setup the project:

<em>It will rebuild the mosquitto server (and will purge volumes)</em>

```bash
make dev
```

> Find other `make` helper command in the [Makefile](./Makefile)

The Mosquitto broker is now available on localhost. You can test it easily (require Mosquitto client):

| In one shell:

```bash
mosquitto_sub -h localhost -t "sensor/temperature"
```

| In a second shell:

```bash
mosquitto_pub -h localhost -t sensor/temperature -m 23
```

## Configuration

The config file is in the file [mosquito.conf](./config/mosquitto.conf)

By default we activated the log and data persistance (logs are in the `log` folder, and data are stored in a docker volume).

## Authentication

By default authentication is disactivated

### Enable authentication

Change these Dockerfiles arguments:

#### Example:

    - AUTH_METHOD=password
    - AUTH_USER=admin
    - AUTH_PASSWORD=admin

## TLS

By default TLS is disactivated

### Enable TLS

Change these Dockerfiles arguments for self-signed certificates:

#### Example:

    - TLS=true