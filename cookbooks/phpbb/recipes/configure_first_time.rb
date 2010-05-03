#node[:phpbb][:login]            = node[:params][:user_name]
node[:phpbb][:password]         = node[:params][:password]
node[:phpbb][:domain_name]      = node[:params][:domain_name]

mysql_reset_root_password

mysql_grant "#{node[:phpbb][:db_name]}" do
  action        :run
  db_login      node[:phpbb][:db_login]
  db_host       node[:phpbb][:db_host]
  db_password   node[:phpbb][:db_password]
end

mysql_command "UPDATE #{node[:phpbb][:db_name]}.phpbb_users SET user_password = MD5('#{node[:phpbb][:password]}') WHERE username = '#{node[:phpbb][:login]}';" do
  action :execute
end

bash "update_config" do
  code <<-EOH
perl -p -i -e "s/\\\\\\$dbhost =.*/\\\\\\$dbhost = \'#{node[:phpbb][:db_host]}\';/" #{node[:apache][:default_docroot]}/config.php
perl -p -i -e "s/\\\\\\$dbname =.*/\\\\\\$dbname = \'#{node[:phpbb][:db_name]}\';/" #{node[:apache][:default_docroot]}/config.php
perl -p -i -e "s/\\\\\\$dbuser =.*/\\\\\\$dbuser = \'#{node[:phpbb][:db_login]}\';/" #{node[:apache][:default_docroot]}/config.php
perl -p -i -e "s/\\\\\\$dbpasswd =.*/\\\\\\$dbpasswd = \'#{node[:phpbb][:db_password]}\';/" #{node[:apache][:default_docroot]}/config.php
EOH
end

log "phpBB User - #{node[:phpbb][:login]}"
log "phpBB Password - #{node[:phpbb][:password]}"
