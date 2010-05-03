%w{ tomcat6 tomcat6-admin }.each do |pkg|
  package pkg do
    action :install
  end
end

bash "tomcat_env_vars" do
  code <<-EOH
echo 'CATALINA_HOME="#{node[:tomcat6][:catalina_home]}"' | sudo tee -a /etc/environment
echo 'CATALINA_BASE="#{node[:tomcat6][:catalina_base]}"' | sudo tee -a /etc/environment
EOH
end

template "/etc/default/tomcat6" do
  source "tomcat6.erb"
  backup false
end

#fix https://bugs.launchpad.net/ubuntu/+source/tomcat6/+bug/410379
remote_file "#{node[:tomcat6][:config_dir]}/policy.d/03catalina.policy" do
  source "03catalina.policy"
  backup false
end
