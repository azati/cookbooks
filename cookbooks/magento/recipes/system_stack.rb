case node[:magento][:system_stack]
when "start"
  magento_system_stack do
    action :start
  end
when "stop"
  magento_system_stack do
    action :stop
  end
when "restart"
  magento_system_stack do
    action :restart
  end
end