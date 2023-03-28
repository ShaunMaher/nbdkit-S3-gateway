FROM debian:sid AS builder

RUN apt update; apt install -y \
  build-essential \
  nbd-client \
  nbdkit \
  nbdkit-plugin-python \
  nbdkit-plugin-dev \
  libcurl4-openssl-dev \
  libfuse-dev \
  libexpat1-dev \
  libssl-dev \
  zlib1g-dev \
  pkg-config \
  autoconf \
  automake \
  libtool \
  git

COPY build-s3backer.sh /build-s3backer.sh
RUN /build-s3backer.sh

FROM debian:sid

RUN apt update; apt install -y \
  nbd-client \
  nbdkit \
  nbdkit-plugin-python \
  nbdkit-plugin-dev \
  libfuse2 \
  libcurl4 \
  supervisor

COPY --from=builder /usr/bin/s3backer /usr/bin/s3backer
COPY --from=builder /usr/lib/x86_64-linux-gnu/nbdkit/plugins/nbdkit-s3backer-plugin.* /usr/lib/x86_64-linux-gnu/nbdkit/plugins/

COPY entrypoint.sh /entrypoint.sh
COPY reset-mounted-flag.sh /reset-mounted-flag.sh
COPY supervisor.conf /etc/supervisor/conf.d/supervisord.conf

#ENTRYPOINT /entrypoint.sh
CMD ["supervisord", "-c", "/etc/supervisor/conf.d/supervisord.conf", "-n"]