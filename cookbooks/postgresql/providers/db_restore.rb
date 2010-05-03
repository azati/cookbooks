action :execute do
  execute "restore_postgresql_databases" do
    command "sudo -u postgres psql -f #{new_resource.name} postgres"
  end
end