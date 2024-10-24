 FROM eclipse-mosquitto:2 as mosquitto-base

ARG UID
ARG GID
ARG USER

ENV AUTH_METHOD=false
ENV AUTH_USER=admin
ENV AUTH_PASSWORD=admin
ENV TLS=false

COPY config/mosquitto.conf /mosquitto/config/mosquitto.conf
COPY bin/entrypoint.sh /mosquitto/entrypoint.sh


CMD /mosquitto/entrypoint.sh -a ${AUTH_METHOD} -u ${AUTH_USER} -p ${AUTH_PASSWORD} -s ${TLS}

FROM python:3-alpine3.10 as client

ENV ROLE=publisher

WORKDIR /app

COPY clients/requirements.txt .

RUN pip install -r requirements.txt

COPY clients .

CMD python3 ${ROLE}.py