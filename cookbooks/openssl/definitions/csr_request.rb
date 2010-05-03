define :csr_request do

  if File.exist?("#{node[:openssl][:pk_dir]}/private.key")
    execute "generate csr without private key" do
      command "openssl req -new -newkey rsa:#{node[:openssl][:bits]} -nodes -key #{node[:openssl][:pk_dir]}/private.key -out /tmp/request.csr -subj \"/C=#{node[:openssl][:country_name]}/ST=#{node[:openssl][:state_name]}/L=#{node[:openssl][:locality_name]}/O=#{node[:openssl][:company_name]}/OU=#{node[:openssl][:organizational_unit_name]}/CN=#{node[:openssl][:domain_name]}\""
    end
  else
    execute "generate csr with private key" do
      command "openssl req -new -newkey rsa:#{node[:openssl][:bits]} -nodes -keyout #{node[:openssl][:pk_dir]}/private.key -out /tmp/request.csr -subj \"/C=#{node[:openssl][:country_name]}/ST=#{node[:openssl][:state_name]}/L=#{node[:openssl][:locality_name]}/O=#{node[:openssl][:company_name]}/OU=#{node[:openssl][:organizational_unit_name]}/CN=#{node[:openssl][:domain_name]}\""
    end
  end

  ruby_block "read" do
    block do
      node[:openssl][:csr_request]=File.read("/tmp/request.csr")
      File.delete("/tmp/request.csr")
      node[:openssl][:private_key]=File.read("#{node[:openssl][:pk_dir]}/private.key")
    end
  end

end