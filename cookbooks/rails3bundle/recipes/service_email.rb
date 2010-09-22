case node[:rails3bundle][:service_email]
when "restart"
  rails3bundle_service_email do
    action :restart
  end
end