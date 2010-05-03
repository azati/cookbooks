#
# This is just an example perl code
# which demonstrates parsing a non standard preformance data
# value and pass the modified string to n2rrd for further processing
#
# see Nagios documentation for  Environment variables passed to plugins 
#
my $tmp_pdata = "";


if ( $ENV{NAGIOS_SERVICEPERFDATA} ) {
        $tmp_pdata = $ENV{NAGIOS_SERVICEPERFDATA};
}

$tmp_pdata =~ s/\'//g;

#Adding STATE info to script result
my $tmp=$ENV{NAGIOS_SERVICESTATE};
my $tmp_state_type=$ENV{NAGIOS_SERVICESTATETYPE};
my $state="";
$state="State= 1 " if ($tmp eq "OK");
$state="State= 2 " if ($tmp eq "WARNING");
$state="State= 3 " if ($tmp eq "UNKNOWN");
$state="State= 4 " if ($tmp eq "CRITICAL");
$state="State= 5 " if ($tmp eq "CRITICAL" & $tmp_state_type eq "HARD");

$tmp_pdata=$state.$tmp_pdata;

# return string in following space seperated format
#  ds_name=ds_value [ds_name=ds_value] ..
return $tmp_pdata;


