# BIND 9 Swarm
Based upon [Mbentley's BIND 9 Docker image](https://github.com/mbentley/docker-bind9), it adds a very simple peer name
resolution mechanism that allows to flexibly configure a network of interconnected DNS servers and clients in a
networked container environment.

## Usage
For each server instance, a list of "peers" can be specified through the environment variable `PEERS` as a space-separated
list:
```
PEERS="tasks.slave-1 tasks.slave-2 client-0"
```

Inside the BIND configuration directory (`/etc/bind/`), a file named `peers.list` is dynamically generated.
Therein, an `acl` and a `masters` clause is defined for every peer, bearing the peer's name as given inside the `PEERS`
variable.

To distinguish between the two kinds of identifiers, a capital `M` is prefixed to the *masters* clause identifiers:
```
acl  "tasks.slave-1" { 172.16.0.25; };
masters  "Mtasks.slave-1" { 172.16.0.25; };
acl  "tasks.slave-2" { 172.16.0.20; };
masters  "Mtasks.slave-2" { 172.16.0.20; };
acl  "client-0" { 172.16.0.18; };
masters  "Mclient-0" { 172.16.0.18; };
```

By including this in the BIND `named.conf` config file, it is now possible to construct ACLs and other sets by relying
solely on the generated identifiers, without considering the real IP addresses of other containers.

## Functioning
The `PEERS` list is processed via the simple `discover_peers.sh` script, which looks up the IP address for each peer
and writes the corresponding entries into the generated `peers.list` file.

To account for delays in container spawning, the script infinitely retries lookups at 10s intervals.

## Extending
All of the added logic is coded into the `discover_peers.sh` script, and the new entrypoint just replaces the one
from the base image and chains the peer discovery script with the original.

If you want to extend this image, just make sure that the correct scipt gets launched and keep in mind the special
meaning the `PEERS` environment variable has.