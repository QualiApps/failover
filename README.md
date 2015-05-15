Keepalived
==============
A simple keepalived container to provide a VIP on docker containers.


###Installation

1. Install [Docker](https://www.docker.com)

2. Download automated build from public Docker Hub Registry: `docker pull qapps/failover`
(alternatively, you can build an image from Dockerfile: `docker build -t="qapps/failover" github.com/qualiapps/failover`)

###Running

`docker run -d --name failover --net=host --privileged --cap-add=NET_ADMIN qapps/failover`

####environment:

    `VIRTUAL_IP`: virtual IP address. `required`

    `INSTANCE_PRIORITY`: must be an integer value (101, 100, ...). Default: 101. If you run a SLAVE instance, you need to type the value less than MASTER value (`required` for SLAVE instance)

    `HAPROXY_IP`: Default: 127.0.0.1

    `HAPROXY_PORT`: Default: 1883

    `INTERFACE`: Default: eth0

    `INSTANCE_STATE`: Default: MASTER


###How To Configure

#####Example scheme

    Load Balencer 1: haproxy1, IP: 192.168.0.101
    Load Balencer 2: haproxy2, IP: 192.168.0.102

####Run keepalived

you need to run keepalived container on each of HAProxy node.

####LB1
running MASTER failover

`docker run -d --name failover --net=host --privileged --cap-add=NET_ADMIN -e "VIRTUAL_IP=192.168.0.100" qapps/failover`

####LB2
running SLAVE failover

`docker run -d --name failover --net=host --privileged --cap-add=NET_ADMIN -e "VIRTUAL_IP=192.168.0.100" -e "INSTANCE_PRIORITY=100" -e "INSTANCE_STATE=BACKUP" qapps/failover`


Installation completed! You can now access your application through VIP, 192.168.0.100 port 1883.