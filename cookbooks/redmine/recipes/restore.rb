redmine_service_web do
  action :stop
end

mysql_reset_root_password

execute "unpack_restore_archive" do
  cwd "/mnt/restore"
  command "tar -xf restore.tar"
end

execute "unpack_mysql_dump" do
  cwd "/mnt/restore"
  command "gzip -d db.sql.gz"
end

mysql_db_restore "/mnt/restore/db.sql" do
  action :execute
end

azati_folder_restore "/mnt/restore/redmine.tar.gz" do
  todir node[:redmine][:dir]
  action :execute
end

azati_folder_restore "/mnt/restore/svn.tar.gz" do
  todir node[:redmine][:svn_dir]
  action :execute
end

execute "subversion_restore" do
  command "cp -f /mnt/restore/subversion /etc/apache2/sites-enabled/subversion"
end

service "mysql" do
  action :restart
end

redmine_service_web do
  action :start
end
