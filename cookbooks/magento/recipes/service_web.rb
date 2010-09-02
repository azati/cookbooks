case node[:magento][:service_web]
when "start"
  magento_service_web do
    action :start
  end
when "stop"
  magento_service_web do
    action :stop
  end
when "restart"
  magento_service_web do
    action :restart
  end
end