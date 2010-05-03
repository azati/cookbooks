case node[:otrs][:service_email]
when "restart"
  otrs_service_email do
    action :restart
  end
end