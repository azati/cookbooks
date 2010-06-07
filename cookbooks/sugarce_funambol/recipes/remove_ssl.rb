include_recipe "apache2::ssl_disable"

bash "remove_certificate" do
  code <<-EOH
#{node[:sugarce_funambol][:funambol_data_dir]}/Funambol/tools/jre-1.6.0/jre/bin/keytool -delete -alias sugarce -storepass changeit -noprompt -keystore #{node[:sugarce_funambol][:funambol_data_dir]}/Funambol/ds-server/lib/security/cacerts
/etc/init.d/funambol stop
/etc/init.d/funambol start
EOH
end
