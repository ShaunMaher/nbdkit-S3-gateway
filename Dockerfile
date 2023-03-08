FROM debian:sid

RUN apt install -y nbdkit nbdkit-plugin-python
COPY entrypoint.sh /entrypoint.sh

ENTRYPOINT /entrypoint.sh