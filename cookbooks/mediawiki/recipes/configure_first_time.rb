#node[:mediawiki][:login]            = node[:params][:user_name]
node[:mediawiki][:password]         = node[:params][:password]
node[:mediawiki][:domain_name]      = node[:params][:domain_name]

mysql_reset_root_password

mysql_grant node[:mediawiki][:db_name] do
  db_login      node[:mediawiki][:db_login]
  db_host       node[:mediawiki][:db_host]
  db_password   node[:mediawiki][:db_password]
  action        :run
end

mysql_command "UPDATE #{node[:mediawiki][:db_name]}.user SET user_password = MD5(CONCAT(user_id, '-', MD5('#{node[:mediawiki][:password]}'))) WHERE user_name = '#{node[:mediawiki][:login]}';" do
  action :execute
end

bash "update_config" do
  code <<-EOH
perl -p -i -e "s/\\\\\\$wgDBserver.*/\\\\\\$wgDBserver = \\"#{node[:mediawiki][:db_host]}\\";/" #{node[:apache][:default_docroot]}/LocalSettings.php
perl -p -i -e "s/\\\\\\$wgDBname.*/\\\\\\$wgDBname = \\"#{node[:mediawiki][:db_name]}\\";/" #{node[:apache][:default_docroot]}/LocalSettings.php
perl -p -i -e "s/\\\\\\$wgDBuser.*/\\\\\\$wgDBuser = \\"#{node[:mediawiki][:db_login]}\\";/" #{node[:apache][:default_docroot]}/LocalSettings.php
perl -p -i -e "s/\\\\\\$wgDBpassword.*/\\\\\\$wgDBpassword = \\"#{node[:mediawiki][:db_password]}\\";/" #{node[:apache][:default_docroot]}/LocalSettings.php
EOH
end

log "MediaWiki User - #{node[:mediawiki][:login]}"
log "MediaWiki Password - #{node[:mediawiki][:password]}"
