node[:monitoring][:components].each do |component|
  include_recipe "monitoring::#{component}"
end

template "/etc/n2rrd/templates/maps/service_name_maps" do
  source "service_name_maps.erb"
  backup false
end

directory "#{node[:nagios][:rra_dir]}/localhost" do
  owner "nagios"
  group "nagios"
  mode   0755
  action :create
end

directory "/etc/cron.azati" do
  action :create
end

remote_file "/etc/cron.azati/nagios-check.sh" do
  source "nagios-check.sh"
end

remote_file "/etc/cron.d/nagios-check" do
  source "nagios-check"
end

#enable nagios
execute "update-rc.d nagios3 defaults 30 18" do
  action :run
end
