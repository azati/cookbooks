bash "set_ssl_config" do
  code <<-EOH
rm -f #{node[:redmine][:certificates][:path]}/nginx.conf
mv -f #{node[:redmine][:certificates][:path]}/nginx.conf.restore #{node[:redmine][:certificates][:path]}/nginx.conf
EOH
end

redmine_service_web do
  action :restart
end

file "#{node[:redmine][:certificates][:path]}/ca_cert.crt" do
  backup false
  action :delete
  only_if do File.exist?("#{node[:redmine][:certificates][:path]}/ca_cert.crt") end
end

file "#{node[:redmine][:certificates][:path]}/cert.crt" do
  backup false
  action :delete
end
