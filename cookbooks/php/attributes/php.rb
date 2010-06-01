set[:php][:dir]                               = "/etc/php5/apache2"
set[:php][:config_dir]                        = "/etc/php5/conf.d"

set[:php][:eaccelerator_ver]                  = "0.9.6.1"
set[:php][:eaccelerator_dir]                  = "/var/cache/eaccelerator"

set[:php][:exposephp]                         = "Off"

set_unless[:php][:display_errors]             = "Off"
set_unless[:php][:magic_quotes_gpc]           = "Off"

set_unless[:php][:memorylimit]                = "64M"
set_unless[:php][:uploadmaxfilesize]          = "30M"
set_unless[:php][:postmaxsize]                = "8M"

set_unless[:php][:mbstring][:func_overload]   = 0

set_unless[:php][:pear_packages]              = []
