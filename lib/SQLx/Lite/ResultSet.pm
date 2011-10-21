package SQLx::Lite::ResultSet;

=head1 NAME

SQLx::Lite::ResultSet - Methods for searching and altering tables

=cut

use SQL::Abstract;

our $sql = SQL::Abstract->new;
use vars qw/$sql/;

our $VERSION = '3.0.5_004';

=head2 primary_key

Sets the primary key for the current ResultSet

    $rs->primary_key('id');

=cut

sub primary_key {
    my ($self, $key) = @_;

    return 0 if ! $key;
    
    $self->{primary_key} = $key;
    return 1;
}

=head2 search

Access to the SQL SELECT query. Returns an array with the selected rows, which contains a hashref of values.
First parameter is an array of what you want returned ie: SELECT this, that
If you enter an empty array ([]), then it will return everything ie: SELECT *
The second parameter is a hash of keys and values of what to search for.

    my $res = $resultset->search([qw/name id status/], { status => 'active' });

    my $res = $resultset->search([], { status => 'disabled' });
    
    my $res = $resultset->search([], { -or => [ name => 'Test', name => 'Foo' ], status => 'active' });

=cut

sub search {
    my ($self, $fields, $c) = @_;
    if (scalar @$fields == 0) { push @$fields, '*'; }
    my ($stmt, @bind) = $sql->select($self->{table}, $fields, $c);
    my ($wstmt, @wbind) = $sql->where($c);
    my $rs = {
        dbh    => $self->{dbh},
        result => $self->{dbh}->selectall_arrayref($stmt, { Slice => {} }, @bind),
        stmt   => $wstmt,
        bind   => \@wbind,
        #where  => $sql->generate('where', $c),
        where  => $c,
        table  => $self->{table},
    };
    
    return bless $rs, 'SQLx::Lite::Result';
}

=head2 insert

Inserts a new record into the current resultset.

    my $insert = $resultset->insert({name => 'Foo', user => 'foo_bar', pass => 'baz'});
    if ($insert) { print "Added user!\n"; }
    else { print "Could not add user\n"; }

=cut

sub insert {
    my ($self, $c) = @_;
    
    my ($stmt, @bind) = $sql->insert($self->{table}, $c);
    my $sth = $self->{dbh}->prepare($stmt);
    my $result = $sth->execute(@bind);

    # make sure it succeeded
    my $res = $self->search([], $c);

    if ($res->count) {
        my $rs = {
            dbh   => $self->{dbh},
            where => $c,
            table => $self->{table},
        };
        
        return bless $rs, 'SQLx::Lite::Result';
    }
    else { return 0; }    
}

1;
