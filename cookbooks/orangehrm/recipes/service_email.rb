case node[:orangehrm][:service_email]
when "restart"
  orangehrm_service_email do
    action :restart
  end
end