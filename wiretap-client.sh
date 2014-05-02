#!/bin/bash

ssh root@192.168.33.100 tcpdump -U -s0 -w - 'not port 22' | wireshark -k -i -
