package SQLx::Lite;

use 5.010;
use DBI;

use SQLx::Lite::DBH;
use SQLx::Lite::ResultSet;
use SQLx::Lite::Result;

$SQLx::Lite::VERSION = '3.0.5_003';

=head1 NAME

SQLx::Lite - Modernish and friendly interface to DBI

=head1 DESCRIPTION

This module is an attempt at a friendly interface to the DBI module. While 
DBI is fantastic, it can be a little daunting to use if you've never used it 
before.
SQLx::Lite attempts to make using it easy, and a little more modern.
This module is still under _heavy_ development and currently only allows you 
to search for results and update them

=head1 SYNOPSIS

    use SQLx::Lite;

    my $dbh = SQLx::Lite->connect(
        dbi    => 'Pg:host=localhost;dbname=test',
        user   => 'username',
        pass   => 'password',
    );

    my $res = $dbh->resultset('users')->search([], { user => 'foo', pass => 'bar' });
    
    if ($res->count > 0) {
        print "Found " . $res->count . " row(s)\n";
        
        for my $row (@{$res->result}) {
            print "Username: $row->{user}\n";
        }
    }

=cut

=head2 connect

Creates the DBI instance using the hash specified. Currently only dbi is mandatory, 
which tells DBI which engine to use (SQLite, Pg, etc).
If you're using SQLite there is no need to set user or pass.

    my $dbh = SQLx::Lite->connect(
        dbi => 'SQLite:/var/db/test.db',
    );

    my $dbh = SQLx::Lite->connect(
        dbi  => 'Pg:host=myhost;dbname=dbname',
        user => 'username',
        pass => 'password',
    );

=cut

sub connect {
    my ($class, %args) = @_;

    my $dbh = DBI->connect(
        'dbi:' . $args{dbi},
        $args{user}||undef,
        $args{pass}||undef,
        { PrintError => 0 }
    ) or do {
        warn 'Could not connect to database: ' . $DBI::errstr;
        return 0;
    };

    my $dbh = { dbh => $dbh };
    bless $dbh, 'SQLx::Lite::DBH';
}

=head1 AUTHOR

Brad Haywood <brad@geeksware.net>

=head1 LICENSE

Same license as Perl

=cut

1;
