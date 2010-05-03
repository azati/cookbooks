#!/bin/bash -e

#USAGE: dmbs-password-reset.sh <USERNAME>

rootpassword=`/opt/azati/lib/dbms-rootpassword-reset.sh`
userpassword=`/opt/azati/lib/generate-random-password.sh`

mysql --user=root --password=$rootpassword -e "UPDATE mysql.user SET Password=PASSWORD('$userpassword') WHERE User='$1';FLUSH PRIVILEGES;"
ret=$?

if [ $ret -eq 0 ]; then
  echo "$password"
fi

exit $ret
