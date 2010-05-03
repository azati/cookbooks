case node[:zencart][:service_web]
when "start"
  zencart_service_web do
    action :start
  end
when "stop"
  zencart_service_web do
    action :stop
  end
when "restart"
  zencart_service_web do
    action :restart
  end
end