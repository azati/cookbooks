case node[:alfresco][:service_email]
when "restart"
  alfresco_service_email do
    action :restart
  end
end