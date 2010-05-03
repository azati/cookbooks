define :postgresql_reset_root_password do
  postgresql_command "ALTER ROLE postgres WITH PASSWORD '#{node[:postgresql][:root_password]}';" do
  action :execute
end
end