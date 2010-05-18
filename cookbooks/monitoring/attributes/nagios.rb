set[:nagios][:dir]              = "/etc/nagios3"
set[:nagios][:n2rrd_dir]        = "/etc/n2rrd"
set[:nagios][:rra_dir]          = "/var/lib/n2rrd"
set[:nagios][:script_dir]       = "/usr/lib/nagios/plugins"

set_unless[:monitoring][:components] = Array.new
