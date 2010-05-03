maintainer       "Azati"
maintainer_email "azati@azati.com"
license          "Apache 2.0"
description      "Installs/Configures monitoring"
long_description IO.read(File.join(File.dirname(__FILE__), 'README.rdoc'))
version          "0.1"
recipe		 "monitoring::nagios_plugins","Install nagios plugins"