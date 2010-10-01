directory "/mnt/backup" do
  action :create
end

mysql_reset_root_password

mysql_db_backup "/mnt/backup/db.sql.gz" do
  action :execute
end

apache2_site_backup "/mnt/backup/site.tar.gz" do
  action :execute
end

execute "metadata_backup" do
  command "cp /opt/azati/shino/config/metadata.yml /mnt/backup/metadata.yml"
end

execute "proftpd_backup" do
  command "cp #{node[:proftpd][:config_path]} /mnt/backup/proftpd.conf"
end

execute "pack_backup" do
  cwd "/mnt/backup"
  command "tar -cf backup.tar db.sql.gz site.tar.gz metadata.yml proftpd.conf"
end

file "/mnt/backup/db.sql.gz" do
  action :delete
  backup false
end

file "/mnt/backup/site.tar.gz" do
  action :delete
  backup false
end

file "/mnt/backup/metadata.yml" do
  action :delete
  backup false
end

file "/mnt/backup/proftpd.conf" do
  action :delete
  backup false
end
