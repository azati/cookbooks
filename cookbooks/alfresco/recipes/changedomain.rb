node[:alfresco][:domain_name] = node[:params][:domain_name]

alfresco_update_domain node[:alfresco][:domain_name]

alfresco_service_web do
  action :restart
end