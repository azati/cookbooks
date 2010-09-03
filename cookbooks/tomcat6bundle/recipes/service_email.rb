case node[:tomcat6bundle][:service_email]
when "restart"
  tomcat6bundle_service_email do
    action :restart
  end
end