case node[:phpbb][:service_email]
when "restart"
  phpbb_service_email do
    action :restart
  end
end