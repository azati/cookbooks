%w{ thin nagios3 nginx }.each do |service|
  update_rc_d "#{service}" do
    action :remove
  end
end

update_rc_d "nginx" do
  action :defaults
  nn     96
end

update_rc_d "thin" do
  action :defaults
  nn     97
end

update_rc_d "nagios3" do
  action :defaults
  nn     99
end

update_rc_d "shino-configure" do
  action :start
  nn     92
  runlvl [2,3,4,5]
end

update_rc_d "shino-boot" do
  action :start
  nn     99
  runlvl [2,3,4,5]
end
