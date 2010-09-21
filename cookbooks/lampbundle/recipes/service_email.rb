case node[:lampbundle][:service_email]
when "restart"
  lampbundle_service_email do
    action :restart
  end
end