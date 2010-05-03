case node[:egroupware][:service_email]
when "restart"
  egroupware_service_email do
    action :restart
  end
end