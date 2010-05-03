set[:nagios][:mysql][:handler]="azati_mysqld_handler"
set[:nagios][:mysql][:n2rrd][:script]="mysql.pl"
set[:nagios][:mysql][:n2rrd][:template]="mysql.t"
set[:nagios][:mysql][:check_command]="$USER1$/check_mysql -u nagios -p Nu71QHuSgOtTxXCIYPKJ"
set[:nagios][:mysql][:handler_command]="$USER1$/eventhandlers/azati_mysqld_handler  $SERVICESTATE$ $SERVICESTATETYPE$ $SERVICEATTEMPT$"
set[:nagios][:mysql][:check_interval]=12
