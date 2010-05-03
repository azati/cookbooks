action :execute do
  if new_resource.dbname.nil?
    execute "postgresql_command" do
      command "sudo -u postgres psql -c \"#{new_resource.name}\""
    end
  else
    execute "postgresql_command" do
      command "sudo -u postgres psql -d #{new_resource.dbname} -c \"#{new_resource.name}\""
    end
  end
end