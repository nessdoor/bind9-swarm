#!/bin/sh

# Discover peers
/discover_peers.sh

# Chain the original entrypoint
exec /entrypoint.docker-bind9.sh "${@}"
