node[:openbravo][:domain_name] = node[:params][:domain_name]

tomcat6_setup_proxy node[:openbravo][:domain_name]

openbravo_service_web do
  action :restart
end