package SQLx::Lite;

use 5.010;
use DBI;

use SQLx::Lite::DBH;
use SQLx::Lite::ResultSet;
use SQLx::Lite::Result;

$SQLx::Lite::VERSION = '3.0.5_002';

=head1 NAME

SQLx::Lite - Modernish interface to the DBI module

=head1 DESCRIPTION

This module is an attempt at a friendly interface to the DBI module. While 
DBI is fantastic, it can be a little daunting to use if you've never used it 
before.
SQLx::Lite attempts to make using it easy, and a little more modern.
This module is still under _heavy_ development and currently only allows you 
to search for results and update them

=head1 SYNOPSIS

    use SQLx::Lite;

    my $dbh = SQLx::Lite->new(
        dbi    => 'Pg:host=localhost;dbname=test',
        user   => 'username',
        pass   => 'password',
    )->connect;

    my $res = $dbh->resultset('users')->search([], { user => 'foo', pass => 'bar' });
    
    if ($res->count > 0) {
        print "Found " . $res->count . " row(s)\n";
        
        for my $row (@{$res->result}) {
            print "Username: $row->{user}\n";
        }
    }

=cut

=head2 new

Sets the needed parameters to connect to DBI. Currently, 
there is dbi, user and pass. Obviously if you're using 
SQLite then you can ommit the username and password.

    my $s = SQLx::Lite->new(
        dbi => 'SQLite:/var/db/test.db',
    );

    my $s = SQLx::Lite->new(
        dbi  => 'Pg:host=myhost;dbname=dbname',
        user => 'username',
        pass => 'password',
    );

=cut

sub new {
    my ($class, %args) = @_;

    my $self = {};
    for (keys %args) {
        $self->{$_} = $args{$_};
    };
    
    return bless $self, $class;
}

=head2 connect

Blesses the DBI connection, if it succeeds as SQLx::Lite::DBH so you 
can use it in resultsets (Tables).

    $dbh = $sqlobj->connect;

The best way to do this is read the SYNOPSIS.

=cut

sub connect {
    my $self = shift;

    my $dbh = DBI->connect(
        'dbi:' . $self->{dbi},
        $self->{user}||undef,
        $self->{pass}||undef,
        { PrintError => 0 }
    ) or do {
        $self->last_error('Could not connect to database: ' . $DBI::errstr);
        return 0;
    };

    $self->{instance}->{dbh} = { dbh => $dbh };
    bless $self->{instance}->{dbh}, 'SQLx::Lite::DBH';
    
    return $self->{instance}->{dbh};
}

=head2 last_error

Set or returns the last error

=cut

sub last_error {
    my ($self, $err) = @_;

    if ($err) { $self->{last_error} = $err; }
    return $self->{last_error};
}

=head1 AUTHOR

Brad Haywood <brad@geeksware.net>

=head1 LICENSE

Same License as Perl

=cut

1;
