#!/bin/bash

ssh vagrant@192.168.33.100 -i ~/.vagrant.d/insecure_private_key sudo tcpdump -i eth1 -U -s0 -w - 'not port 22' | wireshark -k -i -
