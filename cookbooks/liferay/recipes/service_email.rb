case node[:liferay][:service_email]
when "restart"
  liferay_service_email do
    action :restart
  end
end