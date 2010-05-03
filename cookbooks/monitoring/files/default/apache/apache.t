-s 1 # 10seconds
DS:State:GAUGE:120:0:U
DS:Waiting_for_Connect:GAUGE:120:0:U
DS:Starting_Up:GAUGE:120:0:U
DS:Reading_Request:GAUGE:120:0:U
DS:Sending_Reply:GAUGE:120:0:U
DS:Keepalive__read_:GAUGE:120:0:U
DS:DNS_Lookup:GAUGE:120:0:U
DS:Closing_Connection:GAUGE:120:0:U
DS:Logging:GAUGE:120:0:U
DS:Gracefully_finishin:GAUGE:120:0:U
DS:Idle_cleanup:GAUGE:120:0:U
DS:Open_slot:GAUGE:120:0:U
DS:Requests_sec:GAUGE:120:0:U
DS:kB_per_sec:GAUGE:120:0:U
DS:kB_per_Request:GAUGE:120:0:U
RRA:LAST:0.5:60:20160   # two weeks
