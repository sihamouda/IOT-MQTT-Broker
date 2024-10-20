FROM eclipse-mosquitto:2

ARG UID
ARG GID
ARG USER

ARG AUTH_METHOD=false
ARG AUTH_USER
ARG AUTH_PASSWORD

COPY config/mosquitto.conf /mosquitto/config/mosquitto.conf
COPY bin/entrypoint.sh /mosquitto/entrypoint.sh
RUN /mosquitto/entrypoint.sh -a ${AUTH_METHOD} -u ${AUTH_USER} -p ${AUTH_PASSWORD}

CMD /usr/sbin/mosquitto --verbose -c /mosquitto/config/mosquitto.conf
