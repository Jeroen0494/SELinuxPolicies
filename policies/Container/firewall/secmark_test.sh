#!/bin/bash
./secmarkgen -i

./secmarkgen -s INTERNAL

./secmarkgen -n 255.255.255.255,127/8,10.0.0.0/8,172.16.0.0/16,224/24,192.168/16 INTERNAL

./secmarkgen -f -t internal_packet_t INTERNAL

./secmarkgen -s DNS

./secmarkgen -P udp -p 53 DNS

./secmarkgen -P tcp -p 53 DNS

./secmarkgen -f -t dns_external_packet_t DNS

./secmarkgen -s EXTERNAL

./secmarkgen EXTERNAL

./secmarkgen -f -t external_packet_t EXTERNAL

./secmarkgen -T ip6tables -i

./secmarkgen -T ip6tables -s INTERNAL

./secmarkgen -T ip6tables -n FEC0::/10,::1/128,FF::/8,FE80::/10,FC00::/7 INTERNAL

./secmarkgen -T ip6tables -f -t internal_packet_t INTERNAL

./secmarkgen -T ip6tables -s EXTERNAL

./secmarkgen -T ip6tables EXTERNAL

./secmarkgen -T ip6tables -f -t external_packet_t EXTERNAL

