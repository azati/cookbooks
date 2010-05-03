include_recipe "rrdtool::ruby_binding"

%w{open4 right_http_connection activesupport}.each do |gem|
  gem_package gem do
    action :install
  end
end

subversion "Shino" do
  repository "http://devel.azati.com:8080/svn/panel/trunk/shino"
  revision "HEAD"
  destination "/opt/azati/shino"
  svn_username read_setting("Please enter svn login for exporting shino")
  svn_password read_setting("Please enter svn password for exporting shino")
  action :export
end

remote_file "/opt/azati/shino/config/metadata.yml" do
  source "metadatas/#{node[:shino][:metadata]}"
  mode   0755
  owner  "root"
  group  "root"
end

%w{shino-boot shino-configure}.each do |file|
  remote_file "/etc/init.d/#{file}" do
    source "#{file}"
    mode   0777
    owner  "root"
    group  "root"
  end
end

execute "Adding to autorun" do
  command "update-rc.d shino-boot start 99 2 3 4 5 ."
  action  :run
end