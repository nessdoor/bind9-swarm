FROM mbentley/bind9:latest
LABEL maintainer="entropy.overseer@entropic.network"

# Rename the original entrypoint
RUN mv /entrypoint.sh /entrypoint.docker-bind9.sh

COPY discover_peers.sh /discover_peers.sh
COPY entrypoint.sh /entrypoint.sh

ENV PEERS=
