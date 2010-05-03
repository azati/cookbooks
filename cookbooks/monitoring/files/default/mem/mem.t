-s 1 # 10seconds
DS:State:GAUGE:40:0:U
DS:memory_usage:GAUGE:40:0:U
DS:total:GAUGE:40:0:U
DS:used:GAUGE:40:0:U
DS:free:GAUGE:40:0:U
RRA:LAST:0.5:20:60480   # two weeks
