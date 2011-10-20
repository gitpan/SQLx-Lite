#!perl -T

use Test::More tests => 1;

BEGIN {
    use_ok( 'SQLx::Lite' ) || print "Bail out!\n";
}

diag( "Testing SQLx::Lite $SQLx::Lite::VERSION, Perl $], $^X" );
