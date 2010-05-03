include_recipe "apache2::ssl_disable"

execute "perl -p -i -e \"s/^web\\.server\\.protocol=https$/#web\\.server\\.protocol=https/\" #{node[:tomcat6][:catalina_base]}/webapps/ROOT/WEB-INF/classes/portal-ext.properties" do
  action :run
end

liferay_service_web do
  action :restart
end
