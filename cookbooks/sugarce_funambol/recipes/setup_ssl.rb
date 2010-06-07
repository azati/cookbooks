node[:apache][:certificates][:private_key]  = node[:params][:private_key]
node[:apache][:certificates][:cert]         = node[:params][:certificate]
node[:apache][:certificates][:ca_cert]      = node[:params][:ca_certificate]

include_recipe "apache2::ssl_enable"

bash "install_certificate" do
  code <<-EOH
cd /mnt
echo "#{node[:params][:certificate]}" > sugarcecert.crt
#{node[:sugarce_funambol][:funambol_data_dir]}/Funambol/tools/jre-1.6.0/jre/bin/keytool -import -alias sugarce -file sugarcecert.crt -storepass changeit -noprompt -keystore #{node[:sugarce_funambol][:funambol_data_dir]}/Funambol/ds-server/lib/security/cacerts
rm sugarcecert.crt
/etc/init.d/funambol stop
/etc/init.d/funambol start
EOH
end
