set_unless[:openssl][:certs_dir] = "/etc/apache2/conf.d"
set_unless[:openssl][:pk_dir] = "/etc/apache2/conf.d"

set_unless[:openssl][:country_name] = "US"
set_unless[:openssl][:state_name] = "IL"
set_unless[:openssl][:locality_name] = "Chicago"
set_unless[:openssl][:company_name] = "37signals"
set_unless[:openssl][:organizational_unit_name] = "Operations"
set_unless[:openssl][:email_address] = "sysadmins@37signals.com"
set_unless[:openssl][:domain_name] = "domain.com"
set_unless[:openssl][:bits] = 2048

set_unless[:openssl][:csr_request] = ""