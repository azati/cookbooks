openbravo_service_web do
  action :stop
end

execute "unpack_restore_archive" do
  cwd "/mnt/restore"
  command "tar -xf restore.tar"
end

execute "unpack_postgresql_dump" do
  cwd "/mnt/restore"
  command "gzip -d db.sql.gz"
end

postgresql_db_restore "/mnt/restore/db.sql" do
  action :execute
end

azati_folder_restore "/mnt/restore/openbravo.tar.gz" do
  todir "#{node[:tomcat6][:catalina_base]}/webapps/openbravo"
  action :execute
end

azati_folder_restore "/mnt/restore/openbravo_att.tar.gz" do
  todir node[:openbravo][:attach_path]
  action :execute
end

azati_folder_restore "/mnt/restore/openbravo_src.tar.gz" do
  todir node[:openbravo][:src_path]
  action :execute
end

postgresql_reset_root_password

postgresql_command "ALTER ROLE #{node[:openbravo][:db_user]} WITH PASSWORD '#{node[:openbravo][:db_password]}';" do
  action :execute
end

template "#{node[:openbravo][:dir]}/WEB-INF/Openbravo.properties" do
  source "Openbravo.properties.erb"
  backup false
end

service "postgresql-8.4" do
  action :restart
end

openbravo_service_web do
  action :start
end
