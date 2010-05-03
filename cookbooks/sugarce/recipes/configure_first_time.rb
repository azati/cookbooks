node[:sugarce][:login]            = node[:params][:user_name]
node[:sugarce][:password]         = node[:params][:password]
node[:sugarce][:domain_name]      = node[:params][:domain_name]

mysql_reset_root_password

mysql_grant node[:sugarce][:db_name] do
  action :run
  db_login node[:sugarce][:db_login]
  db_host node[:sugarce][:db_host]
  db_password node[:sugarce][:db_password]
end

bash "update_config" do
  code <<-EOH
perl -p -i -e "s/\'db_password\' => \'.*\'/\'db_password\' => \'#{node[:sugarce][:db_password]}\'/" #{node[:apache][:default_docroot]}/config.php
perl -p -i -e "s/\'db_user_name\' => \'.*\'/\'db_user_name\' => \'#{node[:sugarce][:db_login]}\'/" #{node[:apache][:default_docroot]}/config.php
perl -p -i -e "s/\'db_name\' => \'.*\'/\'db_name\' => \'#{node[:sugarce][:db_name]}\'/" #{node[:apache][:default_docroot]}/config.php
perl -p -i -e "s/\'host_name\' => \'.*\'/\'host_name\' => \'#{node[:sugarce][:domain_name]}\'/" #{node[:apache][:default_docroot]}/config.php
perl -p -i -e "s/\'site_url\' => \'.*\'/\'site_url\' => \'http:\\/\\/#{node[:sugarce][:domain_name]}\\/\'/" #{node[:apache][:default_docroot]}/config.php
EOH
end

mysql_command "UPDATE #{node[:sugarce][:db_name]}.users SET user_hash=MD5('#{node[:sugarce][:password]}') WHERE user_name='#{node[:sugarce][:login]}'" do
  action :execute
end

log "SugarCRM User - #{node[:sugarce][:login]}"
log "SugarCRM Password - #{node[:sugarce][:password]}"
