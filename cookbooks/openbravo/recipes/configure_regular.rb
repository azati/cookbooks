node[:openbravo][:domain_name] = node[:params][:domain_name]

tomcat6_setup_proxy node[:openbravo][:domain_name]
