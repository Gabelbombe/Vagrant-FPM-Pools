#!/usr/bin/env bash

touch /home/vagrant/.ssh/config
chown vagrant:vagrant /home/vagrant/.ssh/config
chmod 600 /home/vagrant/.ssh/config

cat << 'EOF' >> /home/vagrant/.ssh/config

  KeepAlive yes
  ServerAliveInterval 45
  StrictHostKeyChecking no

EOF

exit 0
