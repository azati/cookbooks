case node[:magento][:service_email]
when "restart"
 magento_service_email do
    action :restart
  end
end