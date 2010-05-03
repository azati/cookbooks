include_recipe "php::devel"

remote_file "/mnt/eaccelerator-0.9.6.tar.bz2" do
  source "eaccelerator-0.9.6.tar.bz2"
end

bash "compiling & installing eAccelerator 0.9.6" do
  code <<-EOH
cd /mnt
tar -xjf eaccelerator-0.9.6.tar.bz2
cd eaccelerator-0.9.6
phpize
./configure
make
make install
EOH
end

directory "/mnt/eaccelerator-0.9.6" do
  recursive true
  action :delete
end
file "/mnt/eaccelerator-0.9.6.tar.bz2" do
  backup false
  action :delete
end

directory "/var/cache/eaccelerator" do
  owner "www-data"
  group "www-data"
  mode 0644
  action :create
end

template "#{node[:php][:config_dir]}/eaccelerator.ini" do
  source "eaccelerator.ini.erb"
  owner "root"
  group "root"
  mode 0644
  backup false
end
