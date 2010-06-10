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

directory "#{node[:tomcat6][:catalina_base]}/temp" do
  owner node[:tomcat6][:user]
  group node[:tomcat6][:group]
  action :create
end
