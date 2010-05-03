node[:postfix][:relayhost]                      = node[:params][:relay_host]
node[:postfix][:smtp_sasl_auth_enable]          = node[:params][:smtp_auth] ? "yes" : "no"
node[:postfix][:port]                           = node[:params][:port]
node[:postfix][:smtp_sasl_user_name]            = node[:params][:user_name]
node[:postfix][:smtp_sasl_passwd]               = node[:params][:password]
if node[:params][:secure_connection] == "TLS"
  node[:postfix][:smtp_use_tls]                 = "yes"
end
unless node[:params][:from].blank?
  node[:postfix][:sender_constant_field_from]   = node[:params][:from]
end

include_recipe "postfix::email_enable"
