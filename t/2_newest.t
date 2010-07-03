# $Id: 2_newest.t,v 1.4 2009-12-02 20:02:33 dpchrist Exp $

use Test::More 			tests => 2;

use strict;
use warnings;

use Carp;
use Data::Dumper;
use Dpchrist::File::Newest	qw( :all );


$Data::Dumper::Sortkeys = 1;

$| = 1;

my $e;
my $p;
my $r;
my $stdout;
my $stderr;

$r = eval {
    newest;
};
$e = $@;
ok(								#     1
    $e =~ /Required argument LIST missing/,
    'call without arguments should fail'
) or confess join(' ',
    Data::Dumper->Dump([$r, $e], [qw(r e)]),
);

$p = "no/such/path";
$r = eval {
    newest $p;
};
$e = $@;
ok(								#     2
    $e =~ /Path .+ does not exist/,
    'call with invalid path should fail',
) or confess join(' ',
    Data::Dumper->Dump( [$r, $e], [qw(r e)]),
);

