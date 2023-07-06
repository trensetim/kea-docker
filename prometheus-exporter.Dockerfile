FROM debian:bullseye

RUN apt-get update && apt-get -y install python3 python3-pip
RUN apt-get clean
RUN pip install kea-exporter

COPY prometheus-exporter.entrypoint.sh /usr/local/bin/entrypoint.sh
RUN chown root:root /usr/local/bin/entrypoint.sh
RUN chmod u=rx,og= /usr/local/bin/entrypoint.sh

RUN mkdir -p /var/run/kea

VOLUME [ "/var/run/kea" ]
EXPOSE 9500
ENV KEA_EXPORTER_BIND_ADDRESS=0.0.0.0
ENV KEA_EXPORTER_BIND_PORT=9500
ENV KEA_EXPORTER_INTERVAL_SECONDS=30
ENV KEA_EXPORTER_SOCKETS=/var/run/kea/dhcp4.sock
ENTRYPOINT ["/usr/local/bin/entrypoint.sh"]
