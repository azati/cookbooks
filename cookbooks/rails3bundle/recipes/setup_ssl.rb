node[:rails3bundle][:certificates][:private_key]  = node[:params][:private_key]
node[:rails3bundle][:certificates][:cert]         = node[:params][:certificate]
node[:rails3bundle][:certificates][:ca_cert]      = node[:params][:ca_certificate]

template "#{node[:rails3bundle][:certificates][:path]}/private.key" do
  source "certs/private.key.erb"
  owner "root"
  group "root"
  mode 0644
  backup false
end

template "#{node[:rails3bundle][:certificates][:path]}/cert.crt" do
  source "certs/cert.crt.erb"
  owner "root"
  group "root"
  mode 0644
  backup false
end

ruby_block "remove_ca_cert_if_exist" do
  block do
    File.delete("#{node[:rails3bundle][:certificates][:path]}/ca_cert.crt") if File.exist?("#{node[:rails3bundle][:certificates][:path]}/ca_cert.crt")
  end
  action :create
  only_if do node[:rails3bundle][:certificates][:ca_cert] == "" end
end

template "#{node[:rails3bundle][:certificates][:path]}/ca_cert.crt" do
  source "certs/ca_cert.crt.erb"
  owner "root"
  group "root"
  mode 0644
  backup false
  only_if do node[:rails3bundle][:certificates][:ca_cert] != "" end
end

bash "set_ssl_config" do
  code <<-EOH
mv -f #{node[:rails3bundle][:certificates][:path]}/nginx.conf #{node[:rails3bundle][:certificates][:path]}/nginx.conf.restore
cp -f #{node[:rails3bundle][:certificates][:path]}/nginx.conf.ssl #{node[:rails3bundle][:certificates][:path]}/nginx.conf
EOH
end

rails3bundle_service_web do
  action :restart
end
