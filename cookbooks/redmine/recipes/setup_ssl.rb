node[:redmine][:certificates][:private_key]  = node[:params][:private_key]
node[:redmine][:certificates][:cert]         = node[:params][:certificate]
node[:redmine][:certificates][:ca_cert]      = node[:params][:ca_certificate]

template "#{node[:redmine][:certificates][:path]}/private.key" do
  source "certs/private.key.erb"
  owner "root"
  group "root"
  mode 0644
  backup false
end

template "#{node[:redmine][:certificates][:path]}/cert.crt" do
  source "certs/cert.crt.erb"
  owner "root"
  group "root"
  mode 0644
  backup false
end

ruby_block "remove_ca_cert_if_exist" do
  block do
    File.delete("#{node[:redmine][:certificates][:path]}/ca_cert.crt") if File.exist?("#{node[:redmine][:certificates][:path]}/ca_cert.crt")
  end
  action :create
  only_if do node[:redmine][:certificates][:ca_cert] == "" end
end

template "#{node[:redmine][:certificates][:path]}/ca_cert.crt" do
  source "certs/ca_cert.crt.erb"
  owner "root"
  group "root"
  mode 0644
  backup false
  only_if do node[:redmine][:certificates][:ca_cert] != "" end
end

bash "set_ssl_config" do
  code <<-EOH
mv -f #{node[:redmine][:certificates][:path]}/nginx.conf #{node[:redmine][:certificates][:path]}/nginx.conf.restore
cp -f #{node[:redmine][:certificates][:path]}/nginx.conf.ssl #{node[:redmine][:certificates][:path]}/nginx.conf
EOH
end

redmine_service_web do
  action :restart
end
