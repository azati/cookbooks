action :start do

  bash "set_ssl_config" do
    code <<-EOH
rm -f #{node[:rails3bundle][:certificates][:path]}/nginx.conf
mv -f #{node[:rails3bundle][:certificates][:path]}/nginx.conf.restore #{node[:rails3bundle][:certificates][:path]}/nginx.conf
EOH
  end

  service "thin" do
    action :start
  end

  service "nginx" do
    action :restart
  end

  service "nagios3" do
    action :start
  end

end

action :stop do

  if node[:chef_advanced_params][:ssl][:enable]
    bash "set_ssl_config" do
      code <<-EOH
mv -f #{node[:rails3bundle][:certificates][:path]}/nginx.conf #{node[:rails3bundle][:certificates][:path]}/nginx.conf.restore
cp -f #{node[:rails3bundle][:certificates][:path]}/nginx.conf.ssl-maintenance #{node[:rails3bundle][:certificates][:path]}/nginx.conf
EOH
    end
  else
    bash "set_ssl_config" do
      code <<-EOH
mv -f #{node[:rails3bundle][:certificates][:path]}/nginx.conf #{node[:rails3bundle][:certificates][:path]}/nginx.conf.restore
cp -f #{node[:rails3bundle][:certificates][:path]}/nginx.conf.nossl-maintenance #{node[:rails3bundle][:certificates][:path]}/nginx.conf
EOH
    end
  end

  service "nagios3" do
    action :stop
  end

  service "nginx" do
    action :restart
  end

  service "thin" do
    action :stop
  end

end

action :restart do

  service "nagios3" do
    action :stop
  end

  service "thin" do
    action :restart
  end

  service "nginx" do
    action :restart
  end

  service "nagios3" do
    action :start
  end

end