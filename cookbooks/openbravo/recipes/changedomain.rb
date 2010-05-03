node[:openbravo][:domain_name] = node[:params][:domain_name]

openbravo_update_domain node[:openbravo][:domain_name]

openbravo_service_web do
  action :restart
end