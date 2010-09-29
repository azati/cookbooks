action :update do
  node[:proftpd][:encrypted_password] = `/opt/azati/lib/ftpasswd_hash_gen.sh #{new_resource.password}`.strip

  template "/etc/proftpd/proftpd.conf" do
    source "proftpd.conf.erb"
    cookbook "proftpd"
    owner "root"
    group "root"
    mode "0644"
    variables({
      :ftp_login => new_resource.login,
      :encrypted_password => node[:proftpd][:encrypted_password],
      :system_login => new_resource.system_login
    })
    backup false
  end

  service "proftpd" do
    action :restart
  end
end
