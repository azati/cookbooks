directory "/mnt/backup" do
  action :create
end

mysql_reset_root_password

mysql_db_backup "/mnt/backup/db.sql.gz" do
  action :execute
end

azati_folder_backup node[:redmine][:dir] do
  tofile "/mnt/backup/redmine.tar.gz"
  action :execute
end

azati_folder_backup node[:redmine][:svn_dir] do
  tofile "/mnt/backup/svn.tar.gz"
  action :execute
end

execute "metadata_backup" do
  command "cp /opt/azati/shino/config/metadata.yml /mnt/backup/metadata.yml"
end

execute "subversion_backup" do
  command "cp /etc/apache2/sites-enabled/subversion /mnt/backup/subversion"
end

execute "pack_backup" do
  cwd "/mnt/backup"
  command "tar -cf backup.tar db.sql.gz redmine.tar.gz svn.tar.gz metadata.yml subversion"
end

file "/mnt/backup/db.sql.gz" do
  action :delete
  backup false
end

file "/mnt/backup/redmine.tar.gz" do
  action :delete
  backup false
end

file "/mnt/backup/svn.tar.gz" do
  action :delete
  backup false
end

file "/mnt/backup/metadata.yml" do
  action :delete
  backup false
end
