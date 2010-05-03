ports = node[:apache][:listen_ports].include?("443") ? node[:apache][:listen_ports] - ["443"] : node[:apache][:listen_ports]

template "#{node[:apache][:dir]}/ports.conf" do
  source "ports.conf.erb"
  variables :apache_listen_ports => ports
  backup false
end

apache_module "ssl" do
  enable false
  conf true
end

apache_site "default-ssl" do
  enable false
end

apache_site "default" do
  enable true
end

service "apache2" do
  action :restart
end

file "#{node[:apache][:certs_dir]}/ca_cert.crt" do
  backup false
  action :delete
end

file "#{node[:apache][:certs_dir]}/cert.crt" do
  backup false
  action :delete
end
