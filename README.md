# Docker DNSMASQ

[![Docker Pulls](https://img.shields.io/docker/pulls/strm/dnsmasq.svg?style=plastic)](https://hub.docker.com/r/strm/dnsmasq/)

Dnsmasq is a lightweight, easy to configure, DNS forwarder and DHCP server. It is designed to provide DNS and optionally, DHCP, to a small network. It can serve the names of local machines which are not in the global DNS. The DHCP server integrates with the DNS server and allows machines with DHCP-allocated addresses to appear in the DNS with names configured either in each host or in a central configuration file. Dnsmasq supports static and dynamic DHCP leases and BOOTP/TFTP for network booting of diskless machines.

# Example in a docker-compose

Here is a `docker-compose.yml` file that run a local dns server using this image. You can adapt it for your own needs as you wish.

```
version: '2'
services:
    dns:
        restart: always
        image: strm/dnsmasq
        volumes:
            - ./dnsmasq.conf:/etc/dnsmasq.conf
        ports:
            - "53:53/udp"
        cap_add:
            - NET_ADMIN
```

# Deploy with ansible demo playbook

Is possible to deploy with ansible using [this
role](https://github.com/opsxcq/ansible-role-linux-server) to create a complete
Debian buster setup with docker and everything else that you may need.

```yaml
- hosts: all
  vars:
    hostname: "my_dns_server"
    domain: "strm.sh"
    network:
      ip: "192.168.0.9"
      gateway: "192.168.0.1"
      dns: "8.8.8.8"
    github_user: opsxcq
  tasks:
  - name: "Network | Create DNS container"
    copy:
      dest: /config/dnsmasq.conf
      content: |
        #log all dns queries
        log-queries
        #dont use hosts nameservers
        no-resolv
        #use google as default nameservers
        server=8.8.4.4
        server=8.8.8.8
        #explicitly define host-ip mappings
        address=/server/10.1.1.2
        address=/server/10.1.1.2

  - name: "Network | Create DNS container"
    docker_container:
      name: dns
      image: strm/dnsmasq
      restart_policy: unless-stopped
      ports:
        - "53:53/tcp"
        - "53:53/udp"
      entrypoint:
        - dnsmasq
        - "-d"
      volumes:
        - /config/dnsmasq.conf:/etc/dnsmasq.conf
      capabilities:
      - NET_ADMIN
  roles:
    - opsxcq.linux_server
```

# Configuration Example

To be able to run the above example, you will need a configuration file. This is a very basic example that has two hosts, but it serve our purpose.

```
#log all dns queries
log-queries
#dont use hosts nameservers
no-resolv
#use google as default nameservers
server=8.8.4.4
server=8.8.8.8
#explicitly define host-ip mappings
address=/router/10.1.1.1
address=/server/10.1.1.2
```



