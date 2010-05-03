remote_file "/mnt/rubygems-1.3.6.tgz" do
  source "rubygems-1.3.6.tgz"
end

bash "install_rubygems" do
  code <<-EOH
cd /mnt
tar xzf rubygems-1.3.6.tgz
cd rubygems-1.3.6
ruby setup.rb
EOH
end

directory "/mnt/rubygems-1.3.6" do
  recursive true
  action :delete
end
file "/mnt/rubygems-1.3.6.tgz" do
  action :delete
  backup false
end
