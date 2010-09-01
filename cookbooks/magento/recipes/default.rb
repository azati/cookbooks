#Magento Community Edition

node[:magento][:domain_name] = node[:amazon][:public_hostname]

include_recipe "azati::apt_update"

include_recipe "mysql::server"
include_recipe "mysql::mysql_dev"
include_recipe "apache2"
include_recipe "apache2::mod_rewrite"
include_recipe "php"
include_recipe "php::php-curl"
include_recipe "php::php-mysql"
include_recipe "php::php-gd"
include_recipe "php::php-mcrypt"
include_recipe "php::php-pear"
include_recipe "php::php-cli"
include_recipe "php::php-eaccelerator"

service "apache2" do
  action :restart
end

service "mysql" do
  action :restart
end

mysql_reset_root_password

mysql_command "CREATE DATABASE #{node[:magento][:db_name]} DEFAULT CHARACTER SET utf8;" do
  action :execute
end
mysql_command "GRANT ALL ON #{node[:magento][:db_name]}.* TO '#{node[:magento][:db_login]}'@'#{node[:magento][:db_host]}' IDENTIFIED BY '#{node[:magento][:db_password]}';" do
  action :execute
end

bash "install_magento_step1" do
  code <<-EOH
cd #{node[:apache][:default_docroot]}
wget http://www.magentocommerce.com/downloads/assets/#{node[:magento][:installer_version]}/magento-downloader-#{node[:magento][:installer_version]}.tar.gz
tar -zxvf magento-downloader-#{node[:magento][:installer_version]}.tar.gz
mv magento/* magento/.htaccess .
chmod -R o+w media
./pear mage-setup .
./pear install magento-core/Mage_All_Latest-stable
touch var/.htaccess | mkdir app/etc
chmod o+w var var/.htaccess app/etc
rm -rf downloader/pearlib/cache/* downloader/pearlib/download/*
rm -rf magento/ magento-downloader-#{node[:magento][:installer_version]}.tar.gz
EOH
end

bash "install_magento_step2" do
  code <<-EOH
cd #{node[:apache][:default_docroot]}
php -f install.php -- \
--license_agreement_accepted "yes" \
--locale "en_US" \
--timezone "America/Los_Angeles" \
--default_currency "USD" \
--db_host "#{node[:magento][:db_host]}" \
--db_name "#{node[:magento][:db_name]}" \
--db_user "#{node[:magento][:db_login]}" \
--db_pass "#{node[:magento][:db_password]}" \
--session_save "db" \
--url "http://#{node[:magento][:domain_name]}/" \
--use_rewrites "yes" \
--use_secure "no" \
--secure_base_url "https://#{node[:magento][:domain_name]}/" \
--use_secure_admin "no" \
--admin_firstname "admin" \
--admin_lastname "admin" \
--admin_email "admin@noemail.no" \
--admin_username "admin" \
--admin_password "admin11"
EOH
end

if node[:azati][:stack]
  mysql_command "CREATE USER 'nagios'@'localhost' IDENTIFIED BY 'Nu71QHuSgOtTxXCIYPKJ'" do
    action :execute
  end

  include_recipe "monitoring"
end

service "apache2" do
  action :restart
end

service "mysql" do
  action :restart
end

ruby_block "show_password" do
  block do
    loop do
      Chef::Log.info "Now check your Magento application with following settings:"
      Chef::Log.info "Login:       admin"
      Chef::Log.info "Password:    admin11"
      printf "Ready to post install? [yes or ctrl+c to terminate]"
      break if ::Readline.readline('> ', false) == "yes"
    end
  end
  action :create
end
