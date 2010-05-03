-s 1 # 10seconds
DS:State:GAUGE:20:0:U
DS:tps:GAUGE:20:0:U
DS:KB_read_s:GAUGE:20:0:U
DS:KB_written_s:GAUGE:20:0:U
RRA:LAST:0.5:10:120960   # two weeks
