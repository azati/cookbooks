if platform?("centos", "redhat", "fedora")
  package "mod_ssl" do
    action :install
    notifies :run, resources(:execute => "generate-module-list"), :immediately
  end

  file "#{node[:apache][:dir]}/conf.d/ssl.conf" do
    action :delete
    backup false
  end
end

ports = node[:apache][:listen_ports].include?("443") ? node[:apache][:listen_ports] : [node[:apache][:listen_ports], "443"].flatten

template "#{node[:apache][:dir]}/ports.conf" do
  source "ports.conf.erb"
  variables :apache_listen_ports => ports
  backup false
end

template "#{node[:apache][:pk_dir]}/private.key" do
  source "private.key.erb"
  owner "root"
  group "root"
  mode 0644
  backup false
end

template "#{node[:apache][:certs_dir]}/cert.crt" do
  source "cert.crt.erb"
  owner "root"
  group "root"
  mode 0644
  backup false
end

ruby_block "remove_ca_cert_if_exist" do
  block do
    File.delete("#{node[:apache][:certs_dir]}/ca_cert.crt") if File.exist?("#{node[:apache][:certs_dir]}/ca_cert.crt")
  end
  action :create
  only_if do node[:apache][:certificates][:ca_cert] == "" end
end

template "#{node[:apache][:certs_dir]}/ca_cert.crt" do
  source "ca_cert.crt.erb"
  owner "root"
  group "root"
  mode 0644
  backup false
  only_if do node[:apache][:certificates][:ca_cert] != "" end
end

apache_module "ssl" do
  conf true
  enable true
end

#"000-default" here and "default" in ssl_disable because
#a2ensite adds "000-" to "default" to ensure that "default" site config will load first
apache_site "000-default" do
  enable false
end

apache_site "default-ssl" do
  enable true
end

service "apache2" do
  action :restart
end