case node[:joomla][:service_email]
when "restart"
  joomla_service_email do
    action :restart
  end
end