node[:apache][:certificates][:private_key]  = node[:params][:private_key]
node[:apache][:certificates][:cert]         = node[:params][:certificate]
node[:apache][:certificates][:ca_cert]      = node[:params][:ca_certificate]

include_recipe "apache2::ssl_enable"
