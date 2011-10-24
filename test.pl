#!/usr/bin/env perl

use 5.010;
use SQLx::Lite;

my $schema = SQLx::Lite->connect(
    dbi      => 'SQLite:test.db',
    #dbi     => 'Pg:host=localhost;dbname=billing_test',
    #user    => 'billing',
    #pass    => 'billingpass$',
);

my $rs = $schema->resultset('users');
my $res = $rs->insert({
    user => 'foo',
    pass => 'foopass$',
    name => 'Foo Bar',
});

say "Got ID " . $res->insert_id;

#my $res = $rs->search([], {
#        account_code => 4610,
#});
#
#while(my $row = $res->next) {
#    say $row->{serial_number};
#}
