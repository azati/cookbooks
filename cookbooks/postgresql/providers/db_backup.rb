action :execute do
  execute "pg_dumpall" do
    command "sudo -u postgres pg_dumpall -c | gzip -c > #{new_resource.name}"
  end
end