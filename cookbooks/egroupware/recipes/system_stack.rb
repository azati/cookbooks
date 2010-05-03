case node[:egroupware][:system_stack]
when "start"
  egroupware_system_stack do
    action :start
  end
when "stop"
  egroupware_system_stack do
    action :stop
  end
when "restart"
  egroupware_system_stack do
    action :restart
  end
end