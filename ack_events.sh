#!/usr/bin/perl

use warnings;
use strict;

binmode( STDOUT, ':utf8' );
binmode( STDERR, ':utf8' );
use FindBin qw($Bin);
use File::Basename;

use lib "/etc/zabbix/scripts/api";
use Data::Dumper;
use ZabbixAPI;
use Getopt::Long;

my $eventid = $ARGV[0];
my $logpath = '/var/log/zabbix/autoclose.log';
my $username = 'autoclose';
my $password = 'Heslo123.';
my $api_url  = 'http://<serverIP>/zabbix/api_jsonrpc.php';
my $filter   = ''; #use this filter to import only files that contain this sequence.
my $opt_help = 0;
my $help = <<'END_PARAMS';
To import a single image:
    import-images.pl [options] icon.png
     Options:
       --api_url,--url     Zabbix API URL, default is http://localhost/zabbix/api_jsonrpc.php
       --username,-u       Zabbix API user, default is 'Admin'
       --password,-p       Zabbix API user's password, default is 'zabbix'
To import all images from the directory:
    import-images.pl [options] dir_with_icons
     Options:
       --api_url,--url     Zabbix API URL, default is http://localhost/zabbix/api_jsonrpc.php
       --username,-u       Zabbix API user, default is 'Admin'
       --password,-p       Zabbix API user's password, default is 'zabbix'
       --filter            Imports only files that contain filter specified in their filenames.
END_PARAMS
GetOptions(
    "api_url|url=s" => \$api_url,
    "password|p=s"  => \$password,
    "username|u=s"  => \$username,
    "filter|lang=s" => \$filter,
    "help|?"        => \$opt_help
) or die("$help\n");

if ($opt_help) {
    print "$help\n";
    exit 0;
}

open (my $fileh, ">>", $logpath) or die "Can't open the file: $!";

print $fileh " Closing EventID:".$eventid."\n";

my $zbx = ZabbixAPI->new( { api_url => $api_url, username => $username, password => $password } );

$zbx->login();
my $jsonack = {
             eventids =>$eventid,
             action => '2',
             message => 'ACK by autoclose'
            };

my $resack = $zbx->do('event.acknowledge', $jsonack);
print $fileh Dumper($resack);

my $json = {
             eventids =>$eventid,
             action => '1'
            };


my $response = $zbx->do('event.acknowledge', $json);

# print "List of Triggers\n-----------------------------\n";
#foreach my $host (@{$response}) {
#print "TriggerID: ".$host->{triggerid}." Desc: ".$host->{description}."\n";
#}
print $fileh Dumper($response);
$zbx->logout();
close $fileh;




