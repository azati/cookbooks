package "php5" do
  action :install
end

template "#{node[:php][:dir]}/php.ini" do
  source "php.ini.erb"
  owner "root"
  group "root"
  mode 0644
  backup false
end
