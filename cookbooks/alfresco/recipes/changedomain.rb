node[:alfresco][:domain_name] = node[:params][:domain_name]

tomcat6_setup_proxy node[:alfresco][:domain_name]

alfresco_service_web do
  action :restart
end
