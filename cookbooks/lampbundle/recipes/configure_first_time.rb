#node[:lampbundle][:login]            = node[:params][:user_name]
node[:lampbundle][:password]         = node[:params][:password]
node[:lampbundle][:domain_name]      = node[:params][:domain_name]

mysql_reset_root_password

mysql_grant node[:lampbundle][:db_name] do
  action :run
  db_login node[:lampbundle][:db_login]
  db_host node[:lampbundle][:db_host]
  db_password node[:lampbundle][:db_password]
end

bash "save_settings_in_file" do
  code <<-EOH
cat <<EOL >> /root/bundle_settings.txt
Mysql hostname - #{node[:lampbundle][:db_host]}
Mysql dbname   - #{node[:lampbundle][:db_name]}
Mysql login    - #{node[:lampbundle][:db_login]}
Mysql password - #{node[:lampbundle][:db_password]}
------------------------
Apache config dir - #{node[:apache][:dir]}
Apache htdocs dir - #{node[:apache][:default_docroot]}
EOL
EOH
end
