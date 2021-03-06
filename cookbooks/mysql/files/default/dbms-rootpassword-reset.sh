#!/bin/bash -e

start_mysql() {
        #Run mysql with no network and no password security
        /usr/bin/mysqld_safe --skip-grant-tables --skip-networking > /dev/null 2>&1 &
        ret=$?
        # Spin for a maximum of N seconds waiting for the server to come up.
        # Rather than assuming we know a valid username, accept an "access
        # denied" response as meaning the server is functioning.
        if [ $ret -eq 0 ]; then
            STARTTIMEOUT=30
            while [ $STARTTIMEOUT -gt 0 ]; do
              RESPONSE=`/usr/bin/mysqladmin -uUNKNOWN_MYSQL_USER ping 2>&1` && break
              echo "$RESPONSE" | grep -q "Access denied for user" && break
              sleep 1
              let STARTTIMEOUT=${STARTTIMEOUT}-1
            done
            if [ $STARTTIMEOUT -eq 0 ]; then
                    echo "Timeout error occurred trying to start MySQL Daemon."
                    echo "Starting $prog: failed" 
                    ret=1
            fi
        else
            echo "Starting $prog: failed"
        fi
        [ $ret -eq 0 ]
        return $ret
}

password=`/opt/azati/lib/generate-random-password.sh`

set +e
service mysql stop > /dev/null 2>&1
killall -qw mysqld > /dev/null
set -e

sleep 1

start_mysql

ret=$?
if [ $ret -eq 0 ]; then
	mysql -e "UPDATE mysql.user SET Password=PASSWORD('$password') WHERE User='root';FLUSH PRIVILEGES;"
	ret=$?
	if [ $ret -eq 0 ]; then
		set +e
		service mysql stop > /dev/null 2>&1
		killall -qw mysqld > /dev/null
		set -e
		sleep 1
		service mysql start > /dev/null
		ret=$?
		if [ $ret -eq 0 ]; then
			echo "$password"
		fi
	fi
fi

exit $ret
