directory "/mnt/tmp" do
  action :create
end

remote_file "/mnt/tmp/nagios-plugins-1.4.11.tar.gz" do
  source "nagios-plugins-1.4.11.tar.gz"
end

bash "install_nagios_plugins" do
  cwd "/mnt/tmp"
  user "root"
  code <<-EOH
    tar xzf nagios-plugins-1.4.11.tar.gz
    cd nagios-plugins-1.4.11
    ./configure --with-nagios-user=nagios --with-nagios-group=nagios
    make
    make install
  EOH
end
