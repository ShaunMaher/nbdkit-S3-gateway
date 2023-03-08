FROM debian:sid

RUN apt install -y ndbkit nbdkit-plugin-python
COPY entrypoint.sh /entrypoint.sh

ENTRYPOINT /entrypoint.sh