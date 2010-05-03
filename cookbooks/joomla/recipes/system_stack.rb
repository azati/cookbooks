case node[:joomla][:system_stack]
when "start"
  joomla_system_stack do
    action :start
  end
when "stop"
  joomla_system_stack do
    action :stop
  end
when "restart"
  joomla_system_stack do
    action :restart
  end
end