case node[:joomla][:service_web]
when "start"
  joomla_service_web do
    action :start
  end
when "stop"
  joomla_service_web do
    action :stop
  end
when "restart"
  joomla_service_web do
    action :restart
  end
end