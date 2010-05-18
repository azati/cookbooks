#!/bin/bash

/usr/lib/nagios/plugins/check_nagios -e 5 -F /var/cache/nagios3/status.dat -C /usr/sbin/nagios3

if [ $? -ne 0 ] ; then
	/etc/init.d/nagios3 restart
fi
