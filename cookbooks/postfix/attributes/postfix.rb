set[:postfix][:dir] = "/etc/postfix"
set_unless[:postfix][:mail_type]  = "client"
set_unless[:postfix][:myhostname] = fqdn
set_unless[:postfix][:mydomain]   = domain rescue ""
set_unless[:postfix][:myorigin]   = "$myhostname"
set_unless[:postfix][:relayhost]  = ""
set_unless[:postfix][:port] = 25
set_unless[:postfix][:mail_relay_networks] = "127.0.0.0/8"

set_unless[:postfix][:smtp_sasl_auth_enable] = "no"
set_unless[:postfix][:smtp_sasl_password_maps]    = "hash:/etc/postfix/sasl_passwd"
set_unless[:postfix][:smtp_sasl_security_options] = "noanonymous"
set_unless[:postfix][:smtp_tls_cafile] = "/etc/postfix/cacert.pem"
set_unless[:postfix][:smtp_use_tls]    = "no"
set_unless[:postfix][:smtp_sasl_user_name] = ""
set_unless[:postfix][:smtp_sasl_passwd]    = ""

set_unless[:postfix][:default_destination_concurrency_limit] = 1
set_unless[:postfix][:soft_bounce] = "yes"

set_unless[:postfix][:sender_constant_field_from] = ""
#set_unless[:postfix][:sender_canonical_maps] = "hash:/etc/postfix/canonical_maps" using static:node[:postfix][:sender_constant_field_from] to override any form field for outgoing messages.
set_unless[:postfix][:local_header_rewrite_clients] = "static:all"



