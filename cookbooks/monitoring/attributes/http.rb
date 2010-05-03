set[:nagios][:http][:n2rrd][:script]="http.pl"
set[:nagios][:http][:n2rrd][:template]="http.t"
set_unless[:nagios][:http][:check_command]="$USER1$/check_http -I localhost -H localhost -u http://localhost/server-status"
set_unless[:nagios][:http][:check_interval]=12
