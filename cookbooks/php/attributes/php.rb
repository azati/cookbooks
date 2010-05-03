set[:php][:dir]                       = "/etc/php5/apache2"
set[:php][:config_dir]                = "/etc/php5/conf.d"

set[:php][:exposephp]                 = "Off"

set_unless[:php][:memorylimit]        = "64M"
set_unless[:php][:uploadmaxfilesize]  = "30M"
set_unless[:php][:postmaxsize]        = "8M"

set_unless[:php][:pear_packages]      = []