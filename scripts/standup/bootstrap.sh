#!/usr/bin/env bash


# Define envvars
# --------------------
export APPDIR=/var/www/html/w
export APPINI=/var/www/html/ini
export HTDOCS=/vagrant/httpdocs

export NUKE=$1


# Update Apache 2.4
# --------------------
apt-get install -y apache2


# Empty GIT_DIR
# --------------------
[[ 1 == $(ls $HTDOCS |wc -l) ]] && {
  rm -fr $HTDOCS/*
}


# Nuke and pave...
# --------------------
[[ 'true' == $nuke ]] && {
  # Delete default apache web dir and symlink mounted vagrant dir from host machine
  # --------------------
  rm -rf   $HTDOCS /var/www/html
  mkdir -p $HTDOCS

  # Symlink back across
  # --------------------
  ln -fs $HTDOCS/ /var/www/html
}


## Add Vagrant as the default Apache Config User/Group
sed -i -e 's/export APACHE_RUN_USER=.*/export APACHE_RUN_USER=vagrant/g'   /etc/apache2/envvars
sed -i -e 's/export APACHE_RUN_GROUP=.*/export APACHE_RUN_GROUP=vagrant/g' /etc/apache2/envvars


# Replace contents of default Apache vhost
# --------------------
VHOST=$(cat <<EOF
Listen 8080
<VirtualHost *:80>
  ServerName        localhost
  DocumentRoot      "$APPDIR"

  SetEnv APP_HOME   $APPDIR
  SetEnv APP_ENV    virtualmachine
  #Include          conf-available/serve-cgi-bin.conf

  ProxyPassMatch    ^/(.*\.php(/.*)?)$ fcgi://127.0.0.1:9000$APPDIR/\$1

  <Directory "$APPDIR">
    Order allow,deny
    Allow from all
    AllowOverride FileInfo All

    # New directive needed in Apache 2.4.3:
    Require all granted
  </Directory>

  ErrorLog ${APACHE_LOG_DIR}/error.log
  CustomLog ${APACHE_LOG_DIR}/access.log combined

</VirtualHost>

<VirtualHost *:8080>
  ServerName        localhost
  DocumentRoot      "$APPDIR"

  SetEnv APP_HOME   $APPDIR
  SetEnv APP_ENV    virtualmachine
  #Include          conf-available/serve-cgi-bin.conf

  ProxyPassMatch    ^/(.*\.php(/.*)?)$ fcgi://127.0.0.1:9000$APPDIR/\$1

  <Directory "$APPDIR">
    Order allow,deny
    Allow from all
    AllowOverride FileInfo All

    # New directive needed in Apache 2.4.3:
    Require all granted
  </Directory>

  ErrorLog ${APACHE_LOG_DIR}/error.log
  CustomLog ${APACHE_LOG_DIR}/access.log combined

</VirtualHost>
EOF
)


echo "$VHOST" > /etc/apache2/sites-enabled/000-default.conf

# Enable mod_proxy_fcgi and mod_rewrite
# --------------------
a2enmod proxy_fcgi
a2enmod rewrite

service apache2 restart


## per http://serverfault.com/questions/558283/apache2-config-variable-is-not-defined
source /etc/apache2/envvars