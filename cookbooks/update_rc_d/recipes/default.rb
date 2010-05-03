update_rc_d "nginx" do
  action :defaults
  nn     98
end

#update_rc_d "nginx" do
#  action :start
#  nn     92
#  runlvl [2,3,4,5]
#end