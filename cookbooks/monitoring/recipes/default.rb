include_recipe "monitoring::nagios_plugins"

node[:monitoring][:components].each do |component|
  include_recipe "monitoring::#{component}"
end

template "/usr/local/nagios/etc/nagios.cfg" do
  source "nagios.cfg.erb"
  owner  "nagios"
  group  "nagcmd"
  mode   0755
  backup false
end

template "/etc/n2rrd/templates/maps/service_name_maps" do
  source "service_name_maps.erb"
  owner  "nagios"
  group  "nagcmd"
  mode    0755
  backup false
end

directory "#{node[:nagios][:dir]}/var/rra" do
  owner "nagios"
  group "nagcmd"
  mode   0755
  action :create
end

directory "#{node[:nagios][:dir]}/var/rra/localhost" do
  owner "nagios"
  group "nagcmd"
  mode   0755
  action :create
end

service "nagios" do
  supports [:restart, :reload, :status]
  action :enable
end
