node[:apache][:certificates][:private_key]  = node[:params][:private_key]
node[:apache][:certificates][:cert]         = node[:params][:certificate]
node[:apache][:certificates][:ca_cert]      = node[:params][:ca_certificate]

include_recipe "apache2::ssl_enable"

execute "perl -p -i -e \"s/^#web\\.server\\.protocol=https$/web\\.server\\.protocol=https/\" #{node[:tomcat6][:catalina_base]}/webapps/ROOT/WEB-INF/classes/portal-ext.properties" do
  action :run
end

liferay_service_web do
  action :restart
end
