case node[:openbravo][:service_web]
when "start"
  openbravo_service_web do
    action :start
  end
when "stop"
  openbravo_service_web do
    action :stop
  end
when "restart"
  openbravo_service_web do
    action :restart
  end
end