set[:nagios][:dir]     = "/usr/local/nagios"
set[:nagios][:n2rrd_dir] = "/etc/n2rrd"

set_unless[:monitoring][:components] = Array.new
