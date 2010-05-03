case node[:zencart][:service_email]
when "restart"
  zencart_service_email do
    action :restart
  end
end