case node[:sugarce][:service_web]
when "start"
  sugarce_service_web do
    action :start
  end
when "stop"
  sugarce_service_web do
    action :stop
  end
when "restart"
  sugarce_service_web do
    action :restart
  end
end