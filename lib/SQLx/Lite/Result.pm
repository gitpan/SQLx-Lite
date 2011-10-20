package SQLx::Lite::Result;

=head1 NAME

SQLx::Lite::Result - Class for SQLx::Lite results

=head1 DESCRIPTION

When you perform a ResultSet search it will return and bless it 
as a SQLx::Lite::Result, allowing you to perform Result actions on 
that object.

=cut 

our $VERSION = '3.0.5_001';

=head2 result

Returns the result arrayref.

    for my $row (@{$res->result}) {
        print $row->{mykey} . "\n";
    }

=cut

sub result {
    my ($self, $key) = @_;
    if ($key) { return $self->{result}->[0]->{$key}||0; }
    return $self->{result}||0;
}

=head2 count

Returns the number of rows found

=cut

sub count {
    my $self = shift;

    return scalar @{$self->{result}};
}

=head2 update

Uses the result currently set as the result to update it using 
the arguments defined in the hash.

    my $res = $dbh->resultset('foo_table')->search([], { id => 5132 });
    if ($res->update({name => 'New Name'})) {
        print "Updated!\n";
    }

=cut

sub update {
    my ($self, $args) = @_;

    my $set;
    my $sql;
    if (scalar keys %$args < 2) {
        for (keys %$args) { $set = "$_ = '$args->{$_}'"; }
    }
    else {
        my @attr;
        my @val;
        for (keys %$args) {
            push @attr, "$_ = '$args->{$_}'";
        }
        $set = join ', ', @attr;
    }
    $sql = "UPDATE $self->{table} SET $set WHERE $self->{n_attr}";
    say $sql;
    my $rows = $self->{dbh}->do($sql);
    if ($rows > 0) { return 1; }
    return 0;
}

1;
