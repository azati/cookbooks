case node[:sugarce][:service_email]
when "restart"
  sugarce_service_email do
    action :restart
  end
end