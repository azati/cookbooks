case node[:egroupware][:service_web]
when "start"
  egroupware_service_web do
    action :start
  end
when "stop"
  egroupware_service_web do
    action :stop
  end
when "restart"
  egroupware_service_web do
    action :restart
  end
end