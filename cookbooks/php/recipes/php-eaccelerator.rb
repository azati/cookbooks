include_recipe "php::devel"

remote_file "/mnt/eaccelerator-#{node[:php][:eaccelerator_ver]}.tar.bz2" do
  source "http://data.azati.s3.amazonaws.com/php/eaccelerator-#{node[:php][:eaccelerator_ver]}.tar.bz2"
end

bash "compiling & installing eAccelerator" do
  code <<-EOH
cd /mnt
tar -xjf eaccelerator-#{node[:php][:eaccelerator_ver]}.tar.bz2
cd eaccelerator-#{node[:php][:eaccelerator_ver]}
phpize
./configure
make
make install
EOH
end

directory "/mnt/eaccelerator-#{node[:php][:eaccelerator_ver]}" do
  recursive true
  action :delete
end
file "/mnt/eaccelerator-#{node[:php][:eaccelerator_ver]}.tar.bz2" do
  backup false
  action :delete
end

directory node[:php][:eaccelerator_dir] do
  owner node[:apache][:user]
  group node[:apache][:group]
  mode  "0644"
  action :create
end

template "#{node[:php][:config_dir]}/eaccelerator.ini" do
  source "eaccelerator.ini.erb"
  owner  "root"
  group  "root"
  mode   "0644"
  backup false
end
