package SQLx::Lite::Result;

=head1 NAME

SQLx::Lite::Result - Class for SQLx::Lite results

=head1 DESCRIPTION

When you perform a ResultSet search it will return and bless it 
as a SQLx::Lite::Result, allowing you to perform Result actions on 
that object.

=cut 
use SQL::Abstract;
our $sql = SQL::Abstract->new;

use vars qw/$sql/;

our $VERSION = '3.0.5_003';

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

Updates the current result using the hash specified

    my $res = $dbh->resultset('foo_table')->search([], { id => 5132 });
    if ($res->update({name => 'New Name'})) {
        print "Updated!\n";
    }

=cut

sub update {
    my ($self, $fieldvals) = @_;

    my ($stmt, @bind) = $sql->update($self->{table}, $fieldvals, $self->{where});
    my $sth = $self->{dbh}->prepare($stmt);
    if ($sth->execute(@bind)) { return 1; }
    else { return 0; }
}

=head2 delete

Drops the records in the current search result

    my $res = $resultset->search([], { id => 2 });
    $res->delete; # gone!

=cut

sub delete {
    my ($self) = @_;

    my ($stmt, @bind) = $sql->delete($self->{table}, $self->{where});

    my $sth = $self->{dbh}->prepare($stmt);
    $sth->execute(@bind);
}

1;
