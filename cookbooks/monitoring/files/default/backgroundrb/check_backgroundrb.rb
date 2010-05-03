ERRORS={'OK'=>0,'WARNING'=>1,'CRITICAL'=>2,'UNKNOWN'=>3,'DEPENDENT'=>4}
state = "CRITICAL"
a=`ps aux | grep worker`.scan(/.*packet_worker.*\n/).size
state="OK" if a>0
puts "workers= " + a.to_s
exit ERRORS[state]