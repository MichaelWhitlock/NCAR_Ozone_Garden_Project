#!/usr/bin/perl -T

# bring em in
use strict;
use warnings;
use Template;
use Time::Piece;
use CGI qw(:standard);
use CGI::Session qw/-ip-match/;
use DBI;
use Text::CSV;

# uncomment line below to send debug messages to the browser, comment back when ready for production
#use CGI::Carp qw( warningsToBrowser fatalsToBrowser );


# time vars
my $now = localtime;
my $time_email = $now->strftime('%A, %B %d, %G at %I:%M%p'); 
my $date_current = $now->strftime('%Y.%m.%d'); 
my $time_current = $now->strftime('%R'); 
my $time_file = $now->strftime('%Y%m%d%H%M%S');

# set the more vars
my $email_ryanj = 'ryanj@ucar.edu';

#Database connection for map markers -Hunter
my $data_source = "DBI:mysql:greenteam.cfl3ojixyyg2.us-west-1.rds.amazonaws.com:greenteam.cfl3ojixyyg2.us-west-1.rds.amazonaws.com:database=TannerTester";
my $username = "admin";
my $auth = "greenteam";
my $dbh = DBI->connect($data_source, $username, $auth,
          {RaiseError => 1} );
my $sth = $dbh->prepare("SELECT Latitude,Longitude,MarkerLabel,GardenName FROM GardenLocations");
$sth -> execute();

#using db info to create map markers with popups
my $locations = "<script type='text/javascript'>";
while (my @row = $sth->fetchrow_array()){
    #add the map marker
    $locations = $locations . "var " . $row[2] . " = L.marker([". $row[0] . ", " . $row[1] . "],{icon: greenIcon}).addTo(mymap);";
    #add the popup for the marker
    $locations = $locations . $row[2] . ".bindPopup(\"<form action='' method='post'><input type='submit' name='MapButton' value='$row[3]' /></form>\");";
}
$locations = $locations . "</script>";


# cgi vars
my $cgi = CGI->new;

# tt vars
my %tt_options = (INCLUDE_PATH => 'tmps', ABSOLUTE => 1, EVAL_PERL => 1);
my $tt = Template->new(\%tt_options);
my $tt_vars = {
        mapMarkers => $locations
};


# checking for a form submission
if ($cgi->param('submit')) {
    # get form submission variables
    my $leaf1 = $cgi->param('leaf1');
    my $leaf2 = $cgi->param('leaf2');
    my $leaf3 = $cgi->param('leaf3');
    my $leaf4 = $cgi->param('leaf4');
    my $leaf5 = $cgi->param('leaf5');
    my $leaf6 = $cgi->param('leaf6');
    my $leaf7 = $cgi->param('leaf7');
    my $leaf8 = $cgi->param('leaf8');
    my $leaf9 = $cgi->param('leaf9');
    my $leaf10 = $cgi->param('leaf10');

    my $date = $cgi->param('date-today');
    my $location = $cgi->param('garden-location');
    my $plant = $cgi->param('plant-type');

    # dev message
    $tt_vars->{'msg_err'} = "Worksheet Submitted";
}


# set the template to use
my $tt_template = 'data_add.htm';

# starting stuff
$| = 1;
print "Content-type: text/html\n\n";

# process the template
$tt->process($tt_template, $tt_vars) || die $tt->error();
exit;



# Send a plain-text, UTF-8 email to the specified recipients, taken from account_request.cgi
sub send_email
{
    my ($subject, $content, $from, @recipients) = @_;

    my $cmd = '/usr/sbin/sendmail';
    my @args = qw(-t); # Specify recipients in To: header, not command line

    open my $fh, '|-:utf8', $cmd, @args or die "Failed to start '$cmd' with args @args";

    # Generate SMTP headers for message
    my $headers;
    {
        local $" = ', ';

        $headers =<<MAIL_HEADERS;
            From: $from
            To: @recipients
            Content-type: text/html; charset=utf-8
            Subject: $subject

MAIL_HEADERS
    }

    $headers =~ s/^\s+//gm;
    say $fh $headers;
    say $fh $content;

    close $fh;

    die "'$cmd' killed by signal" . ($? & 127) if $? & 127;
    die "'$cmd' exited with error" . ($? >> 8) if $? >> 8;
}