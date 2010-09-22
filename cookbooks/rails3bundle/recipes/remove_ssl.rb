bash "set_ssl_config" do
  code <<-EOH
rm -f #{node[:rails3bundle][:certificates][:path]}/nginx.conf
mv -f #{node[:rails3bundle][:certificates][:path]}/nginx.conf.restore #{node[:rails3bundle][:certificates][:path]}/nginx.conf
EOH
end

rails3bundle_service_web do
  action :restart
end

file "#{node[:rails3bundle][:certificates][:path]}/ca_cert.crt" do
  backup false
  action :delete
  only_if do File.exist?("#{node[:rails3bundle][:certificates][:path]}/ca_cert.crt") end
end

file "#{node[:rails3bundle][:certificates][:path]}/cert.crt" do
  backup false
  action :delete
end
