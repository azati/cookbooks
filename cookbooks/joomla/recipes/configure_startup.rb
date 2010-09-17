update_rc_d "apache2" do
  action :remove
end

update_rc_d "nagios3" do
  action :remove
end

update_rc_d "apache2" do
  action :defaults
  nn     98
end

update_rc_d "nagios3" do
  action :defaults
  nn     99
end

update_rc_d "shino-configure" do
  action :start
  nn     97
  runlvl [2,3,4,5]
end

update_rc_d "shino-boot" do
  action :start
  nn     99
  runlvl [2,3,4,5]
end