FROM debian:bookworm

RUN apt-get update && apt-get -y install kea-dhcp4-server
RUN apt-get clean

RUN mkdir -p /run/kea \
    /var/lib/kea \
    /etc/kea \
    /var/lib/kea

VOLUME [ "/etc/kea", "/var/lib/kea", "/var/run/kea" ]
# 67, 68 DHCP
EXPOSE 67 68 

ENTRYPOINT ["/usr/sbin/kea-dhcp4", "-c", "/etc/kea/dhcp4.json"]
