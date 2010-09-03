node[:tomcat6bundle][:domain_name] = node[:params][:domain_name]

tomcat6_setup_proxy node[:tomcat6bundle][:domain_name]
