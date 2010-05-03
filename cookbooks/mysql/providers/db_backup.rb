action :execute do
  execute "mysqldump" do
    command "mysqldump --add-drop-database --complete-insert --create-options --disable-keys --extended-insert --single-transaction --quick -h #{node[:mysql][:host]} -uroot -p#{node[:mysql][:root_password]} --all-databases | gzip -c > #{new_resource.name}"
  end
end