[ISC Kea DHCP4-Server](https://gitlab.isc.org/isc-projects/kea) in a container

# Running the image

1. Create the required configuration files ([Kea DHCPv4](sample-etc/kea/dhcp4.json))
1. Create a docker-compose file
```yaml
version: '3'

services:
  dhcp4:
    container_name: kea
    image: docker-registry.gitlab.timtrense.com/tim/kea-docker:latest
    restart: unless-stopped
    network_mode: host
    # enable debugging
    # command: -d
    volumes:
      # provide an empty ./var folder for kea to persist its lease file
      - ./var:/var/lib/kea
      # provide an empty ./run folder for kea to export its UNIX control socket to
      - ./run:/var/run/kea
      # place your "dhcp4.json" configuration file into the ./etc folder
      - ./etc:/etc/kea:ro
  prometheus-exporter:
    container_name: kea-prometheus-exporter
    image: docker-registry.gitlab.timtrense.com/tim/kea-docker/prometheus-exporter:latest
    restart: unless-stopped
    ports:
      - 9500:9500
    volumes:
      # provide the mounted run folder of kea to get this container access to its control socket
      - ./run:/var/run/kea

```
1. Run the container `docker-compose up -d`

# Acknowledgements

Special thanks to [Tomek's Docker Repo for Kea](https://gitlab.isc.org/isc-projects/kea-docker). 
In contrast with this one, this repo here
- provides actual builds
- tracks debian as the base image
- installs stork with the image
