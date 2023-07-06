FROM debian:bullseye

RUN apt-get update && apt-get -y install debian-keyring debian-archive-keyring apt-transport-https curl openssl
RUN curl -1sLf 'https://dl.cloudsmith.io/public/isc/kea-2-2/gpg.A8CB727C62565FF8.key' |  gpg --dearmor > /usr/share/keyrings/isc-kea-2-2-archive-keyring.gpg
RUN curl -1sLf 'https://dl.cloudsmith.io/public/isc/kea-2-2/config.deb.txt?distro=debian&codename=bullseye' > /etc/apt/sources.list.d/isc-kea-2-2.list
RUN apt-get update && apt-get -y install isc-kea-dhcp4-server
RUN apt-get clean

RUN mkdir -p /run/kea \
	/var/lib/kea \
	/etc/kea \
	/var/lib/kea

COPY --chown=root:root entrypoint.sh /usr/bin/entrypoint.sh
RUN chmod u=rx,og= /usr/bin/entrypoint.sh

VOLUME [ "/etc/kea", "/var/lib/kea" ]
# 67, 68 DHCP
EXPOSE 67 68 

ENTRYPOINT ["/usr/sbin/kea-dhcp4", "-c" "/etc/kea/dhcp4.json"]
