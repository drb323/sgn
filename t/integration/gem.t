#!/usr/bin/perl
use strict;
use warnings;

use Test::More tests => 9;
use Test::WWW::Mechanize;
my $base_url = $ENV{SGN_TEST_SERVER};
my $mech = Test::WWW::Mechanize->new;

# TODO: It would be nice if this didn't depend on production data

$mech->get_ok("$base_url/gem/experiment.pl?id=1");
$mech->content_unlike( qr/ERROR PAGE/ );
$mech->content_like( qr/Expression Experiment: TobEA cauline leaf/ );

$mech->get_ok("$base_url/gem/experiment.pl?name=TobEA%20cauline%20leaf");
$mech->content_unlike( qr/ERROR PAGE/ );
$mech->content_like( qr/Expression Experiment: TobEA cauline leaf/ );

$mech->get_ok("$base_url/gem/experiment.pl?name=foob");
$mech->content_unlike( qr/ERROR PAGE/ );
$mech->content_like( qr/No experiment data for the specified parameters/);
