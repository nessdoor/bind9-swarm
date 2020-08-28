#!/bin/sh

target_file=/etc/bind/peers.list

# If already present (e.g. persistent config volume), remove the old target file
if [ -f $target_file ]
then
   rm $target_file
fi

touch $target_file

echo "Looking-up peers..."
for p in $PEERS
do
    resp=$(dig +short $p)

    while [ -z "$resp" ]
    do
        echo "Peer $p isn't up yet. Retrying in 10 seconds..."
        sleep 10
        resp=$(dig +short $p)
    done

    # For this to work, it's important that every name maps to one and only one IP address
    echo "acl \"$p\" { $resp; };" >> $target_file
    echo "masters \"M$p\" { $resp; };" >> $target_file
done
