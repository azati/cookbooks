node[:openssl][:bits]                     = node[:params][:bits]
node[:openssl][:country_name]             = node[:params][:country]
node[:openssl][:state_name]               = node[:params][:state]
node[:openssl][:locality_name]            = node[:params][:location]
node[:openssl][:company_name]             = node[:params][:organization]
node[:openssl][:organizational_unit_name] = node[:params][:department]
node[:openssl][:domain_name]              = node[:params][:domain]
node[:openssl][:certs_dir]                = node[:nginx][:certs_dir]
node[:openssl][:pk_dir]                   = node[:nginx][:pk_dir]

include_recipe "openssl::csr_request"

ruby_block "resulting" do
  block do
    node[:result][:csr_request]=node[:openssl][:csr_request]
    node[:result][:private_key]=node[:openssl][:private_key]
  end
end