#!/bin/bash


#PATH=$PATH:/usr/bin:/usr/sbin
#APACHE_LYNX='/usr/bin/www-browser -dump '
#export APACHE_LYNX='/usr/bin/www-browser -dump '
TERM=vt100

/usr/bin/timeout 30 curl -i 'http://localhost/server-status' &> /dev/null
statusCode=$?
if [ $statusCode -ne 0 ]; then
    echo "Apache restarted ! "
    date >> /root/aut_restart_apache
    /usr/bin/killall -9 apache2 >> /root/aut_restart_apache
    /etc/init.d/apache2 stop >> /root/aut_restart_apache
    /etc/init.d/apache2 start >> /root/aut_restart_apache
fi
