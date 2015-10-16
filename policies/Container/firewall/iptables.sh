#!/bin/bash
# Clear table
iptables -4 -F
iptables -4 -X
iptables -4 -F -t security
iptables -4 -X -t security

# Define variables and chains
INTERNAL="255.255.255.255,127/8,10/8,172.16/12,224/24,192.168/16"
iptables -4 -t security -X INTERNAL 2> /dev/null
iptables -4 -t security -N INTERNAL
iptables -4 -t security -X CONTAINER 2> /dev/null
iptables -4 -t security -N CONTAINER
iptables -4 -t security -X DNS 2> /dev/null
iptables -4 -t security -N DNS
iptables -4 -t security -X EXTERNAL 2> /dev/null
iptables -4 -t security -N EXTERNAL

# Restore established traffic
iptables -4 -t security -A INPUT -m state --state ESTABLISHED,RELATED -j CONNSECMARK --restore
iptables -4 -t security -A OUTPUT -m state --state ESTABLISHED,RELATED -j CONNSECMARK --restore

# Define and mark CONTAINER
iptables -4 -A OUTPUT -t security -p tcp --dport 8888 -j CONTAINER
iptables -4 -A INPUT -t security -p tcp --sport 8888 -j CONTAINER

iptables -4 -t security -A CONTAINER -j SECMARK --selctx system_u:object_r:container_packet_t:s0
iptables -4 -t security -A CONTAINER -j CONNSECMARK --save
iptables -4 -t security -A CONTAINER -j ACCEPT

# Define and mark INTERNAL
iptables -4 -A OUTPUT -t security -d $INTERNAL -j INTERNAL
iptables -4 -A INPUT -t security -s $INTERNAL -j INTERNAL

iptables -4 -t security -A INTERNAL -j SECMARK --selctx system_u:object_r:internal_packet_t:s0
iptables -4 -t security -A INTERNAL -j CONNSECMARK --save
iptables -4 -t security -A INTERNAL -j ACCEPT

# Define and mark DNS
iptables -4 -A OUTPUT -t security -p udp --dport 53 -j DNS
iptables -4 -A INPUT -t security -p udp --sport 53 -j DNS
iptables -4 -A OUTPUT -t security -p tcp --dport 53 -j DNS
iptables -4 -A INPUT -t security -p tcp --sport 53 -j DNS

iptables -4 -t security -A DNS -j SECMARK --selctx system_u:object_r:dns_external_packet_t:s0
iptables -4 -t security -A DNS -j CONNSECMARK --save
iptables -4 -t security -A DNS -j ACCEPT

# Define and mark EXTERNAL
iptables -4 -A OUTPUT -t security -j EXTERNAL
iptables -4 -A INPUT -t security -j EXTERNAL

iptables -4 -t security -A EXTERNAL -j SECMARK --selctx system_u:object_r:external_packet_t:s0
iptables -4 -t security -A EXTERNAL -j CONNSECMARK --save
iptables -4 -t security -A EXTERNAL -j ACCEPT



# Clear tables
ip6tables -6 -F -t security

# Define variables
INTERNAL="FEC0::/10,::1/128,FF::/8,FE80::/10,FC00::/7"

# Restore established traffic
ip6tables -6 -t security -A INPUT -m state --state ESTABLISHED,RELATED -j CONNSECMARK --restore
ip6tables -6 -t security -A OUTPUT -m state --state ESTABLISHED,RELATED -j CONNSECMARK --restore


# Define and mark INTERNAL
ip6tables -6 -t security -X INTERNAL 2> /dev/null
ip6tables -6 -t security -N INTERNAL
ip6tables -6 -A OUTPUT -t security -d $INTERNAL -j INTERNAL
ip6tables -6 -A INPUT -t security -s $INTERNAL -j INTERNAL

ip6tables -6 -t security -A INTERNAL -j SECMARK --selctx system_u:object_r:internal_packet_t:s0
ip6tables -6 -t security -A INTERNAL -j CONNSECMARK --save
ip6tables -6 -t security -A INTERNAL -j ACCEPT


# Define and mark CONTAINER
ip6tables -6 -t security -X CONTAINER 2> /dev/null
ip6tables -6 -t security -N CONTAINER
ip6tables -6 -A OUTPUT -t security -j CONTAINER
ip6tables -6 -A INPUT -t security -j CONTAINER

ip6tables -6 -t security -A CONTAINER -p tcp --dport 8888 -j SECMARK --selctx system_u:object_r:container_packet_t:s0
ip6tables -6 -t security -A CONTAINER -j CONNSECMARK --save
ip6tables -6 -t security -A CONTAINER -j ACCEPT

# Define and mark EXTERNAL
ip6tables -6 -t security -X EXTERNAL 2> /dev/null
ip6tables -6 -t security -N EXTERNAL
ip6tables -6 -A OUTPUT -t security -j EXTERNAL
ip6tables -6 -A INPUT -t security -j EXTERNAL

ip6tables -6 -t security -A EXTERNAL -j SECMARK --selctx system_u:object_r:external_packet_t:s0
ip6tables -6 -t security -A EXTERNAL -j CONNSECMARK --save
ip6tables -6 -t security -A EXTERNAL -j ACCEPT

