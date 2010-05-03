#!/usr/bin/perl -w
# -------------------------------------------------------------[ Enviroment ]--

use strict;

$ENV{PATH} = "/bin:/usr/bin";
$ENV{ENV} = "";
$ENV{BASH_ENV} = "";

my %ERRORS=('OK'=>0,'WARNING'=>1,'CRITICAL'=>2,'UNKNOWN'=>3,'DEPENDENT'=>4);
my $result=`nmap -PS -p 8443 127.0.0.1 | grep 8443`;
$result =~ s/\n//g;
my $state="CRITICAL";
my $perfdata="";
if  ($result =~ /.*open.*/ )
{
    $state="OK"
}  
printf  ($state." - " . $result . " | " . $perfdata . "\n");

exit $ERRORS{$state};

