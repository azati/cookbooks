#!/bin/bash -e

#USAGE: dmbs-rootpassword-reset.sh

# extract value of a MySQL option from config files
# Usage: get_mysql_option SECTION VARNAME DEFAULT
# result is returned in $result
# We use my_print_defaults which prints all options from multiple files,
# with the more specific ones later; hence take the last match.
get_mysql_option(){
        result=`/usr/bin/my_print_defaults "$1" | sed -n "s/^--$2=//p" | tail -n 1`
        if [ -z "$result" ]; then
            # not found, use default
            result="$3"
        fi
}

prog="MySQL"

get_mysql_option mysqld datadir "/var/lib/mysql"
datadir="$result"
get_mysql_option mysqld socket "$datadir/mysql.sock"
socketfile="$result"
get_mysql_option mysqld_safe log-error "/var/log/mysqld.log"
errlogfile="$result"
get_mysql_option mysqld_safe pid-file "/var/run/mysqld/mysqld.pid"
mypidfile="$result"

start_skip_grant_tables(){
        #Run mysql with no network and no password security
        /usr/bin/mysqld_safe --skip-grant-tables  --skip-networking --datadir="$datadir" --socket="$socketfile" \
              --log-error="$errlogfile" --pid-file="$mypidfile" \
              >/dev/null 2>&1 &
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

/etc/init.d/mysql stop > /dev/null
start_skip_grant_tables > /dev/null
ret=$?
if [ $ret -eq 0 ]; then
	mysql -e "UPDATE mysql.user SET Password=PASSWORD('$password') WHERE User='root';FLUSH PRIVILEGES;"
	ret=$?
	if [ $ret -eq 0 ]; then
		/etc/init.d/mysql stop > /dev/null
		ret=$?
		/etc/init.d/mysql start > /dev/null
	        ret=$(($ret | $?))
		if [ $ret -eq 0 ]; then
			echo "$password"
		fi
	fi
fi

exit $ret
