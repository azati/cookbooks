case node[:redmine][:service_email]
when "restart"
  redmine_service_email do
    action :restart
  end
end