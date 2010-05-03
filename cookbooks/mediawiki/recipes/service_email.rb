case node[:mediawiki][:service_email]
when "restart"
  mediawiki_service_email do
    action :restart
  end
end