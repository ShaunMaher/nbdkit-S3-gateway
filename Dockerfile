FROM debian:sid

RUN apt update; apt install -y nbdkit nbdkit-plugin-python
COPY entrypoint.sh /entrypoint.sh

ENTRYPOINT /entrypoint.sh