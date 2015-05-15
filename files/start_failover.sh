#!/bin/bash

VIP=${VIRTUAL_IP:-127.0.0.1} # required
HAPROXY_IP_CHECK=${HAPROXY_IP:-127.0.0.1}
HAPROXY_PORT_CHECK=${HAPROXY_PORT:-1883}
INTERFACE_CHECK=${INTERFACE:-eth0}
STATE=${INSTANCE_STATE:-MASTER}
PRIORITY=${INSTANCE_PRIORITY:-101} # required

# Init failover config
cat>/etc/keepalived/keepalived.conf<<EOF
vrrp_script chk_haproxy {
  script "</dev/tcp/${HAPROXY_IP_CHECK}/${HAPROXY_PORT_CHECK}"
  interval 2
  weight 2
}

vrrp_instance VI_1 {
  interface ${INTERFACE_CHECK}
  state ${STATE}
  virtual_router_id 51
  priority ${PRIORITY}
  virtual_ipaddress {
    ${VIP}
  }
  track_script {
    chk_haproxy
  }
}
EOF

keepalived --dont-fork --log-console