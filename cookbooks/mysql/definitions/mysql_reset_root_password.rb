define :mysql_reset_root_password do
  ruby_block "resetrootpassword" do
    block do
      Chef::Log.info "Resetting mysql root password"
      node[:mysql][:root_password] = `/opt/azati/lib/dbms-rootpassword-reset.sh`.strip
      Chef::Log.info "New password - #{node[:mysql][:root_password]}"
    end
    action :create
  end
end