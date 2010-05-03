action :start do

  bash "set_ssl_config" do
    code <<-EOH
rm -f #{node[:redmine][:certificates][:path]}/nginx.conf
mv -f #{node[:redmine][:certificates][:path]}/nginx.conf.restore #{node[:redmine][:certificates][:path]}/nginx.conf
EOH
  end

  service "thin" do
    action :start
  end

  service "apache2" do
    action :start
  end

  service "nginx" do
    action :restart
  end

  service "nagios" do
    action :start
  end

end

action :stop do

  if node[:chef_advanced_params][:ssl][:enable]
    bash "set_ssl_config" do
      code <<-EOH
mv -f #{node[:redmine][:certificates][:path]}/nginx.conf #{node[:redmine][:certificates][:path]}/nginx.conf.restore
cp -f #{node[:redmine][:certificates][:path]}/nginx.conf.ssl-maintenance #{node[:redmine][:certificates][:path]}/nginx.conf
EOH
    end
  else
    bash "set_ssl_config" do
      code <<-EOH
mv -f #{node[:redmine][:certificates][:path]}/nginx.conf #{node[:redmine][:certificates][:path]}/nginx.conf.restore
cp -f #{node[:redmine][:certificates][:path]}/nginx.conf.nossl-maintenance #{node[:redmine][:certificates][:path]}/nginx.conf
EOH
    end
  end

  service "nagios" do
    action :stop
  end

  service "nginx" do
    action :restart
  end

  service "apache2" do
    action :stop
  end

  service "thin" do
    action :stop
  end

end

action :restart do

  service "nagios" do
    action :stop
  end

  service "thin" do
    action :restart
  end

  service "apache2" do
    action :restart
  end

  service "nginx" do
    action :restart
  end

  service "nagios" do
    action :start
  end

end