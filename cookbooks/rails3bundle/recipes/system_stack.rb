case node[:rails3bundle][:system_stack]
when "start"
  rails3bundle_system_stack do
    action :start
  end
when "stop"
  rails3bundle_system_stack do
    action :stop
  end
when "restart"
  rails3bundle_system_stack do
    action :restart
  end
end