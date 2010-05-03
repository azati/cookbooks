set[:nagios][:nginx][:handler]="azati_nginx_handler"
set[:nagios][:nginx][:script]="check_nginx.sh"
#set[:nagios][:nginx][:cfg]="nginx.cfg"
set[:nagios][:nginx][:n2rrd][:script]="nginx.pl"
set[:nagios][:nginx][:n2rrd][:template]="nginx.t"
set_unless[:nagios][:nginx][:check_interval]=12
