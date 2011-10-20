package SQLx::Lite::ResultSet;

=head1 NAME

SQLx::Lite::ResultSet - Methods for searching and altering tables

=cut

our $VERSION = '3.0.5_001';

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

=cut

sub search {
    my ($self, $sel, $c) = @_;
    my @n_val;
    my @attr;
    my @val;
    for (keys %$c) {
        push @attr, "$_ = ?";
        push @val, $c->{$_};
        push @n_val, "$_ = '$c->{$_}'";
    }
    my $n_val = join ' AND ', @n_val;
    my $attr = join ' AND ', @attr;
    my $select = (scalar @$sel > 0) ? join ',', @$sel : '*';
    my $sql = "SELECT $select FROM $self->{table} WHERE $attr";
    my $sth = $self->{dbh}->prepare($sql);
    my $rs = {
        attr   => $attr,
        n_attr   => $n_val, 
        bind_attr => \@val,
        table   => $self->{table},
        result => $self->{dbh}->selectall_arrayref($sql, { Slice => {} }, @val),
        dbh    => $self->{dbh},
    };
    return bless $rs, 'SQLx::Lite::Result';
}

1;
