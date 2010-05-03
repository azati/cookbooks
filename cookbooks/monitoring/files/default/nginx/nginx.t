-s 1 # 10seconds
DS:State:GAUGE:120:0:U
DS:reqpsec:GAUGE:120:0:U
DS:conpsec:GAUGE:120:0:U
DS:conpreq:GAUGE:120:0:U
RRA:LAST:0.5:60:120960   # two weeks
