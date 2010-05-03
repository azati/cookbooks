case node[:openbravo][:service_email]
when "restart"
  openbravo_service_email do
    action :restart
  end
end