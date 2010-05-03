case node[:orangehrm][:service_web]
when "start"
  orangehrm_service_web do
    action :start
  end
when "stop"
  orangehrm_service_web do
    action :stop
  end
when "restart"
  orangehrm_service_web do
    action :restart
  end
end