node[:liferay][:domain_name] = node[:params][:domain_name]

liferay_update_domain node[:liferay][:domain_name]

liferay_service_web do
  action :restart
end