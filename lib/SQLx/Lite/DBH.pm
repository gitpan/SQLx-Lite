package SQLx::Lite::DBH;

use base 'SQLx::Lite::ResultSet';

use 5.010;

sub resultset {
    my ($self, $table) = @_;

    $self->{resultset} = { table => $table, dbh => $self->{dbh} };
    bless $self->{resultset}, 'SQLx::Lite::ResultSet';
}

sub icall {
    my $self = shift;
    say $self->{dbh};
    say "Icall called!";
}

1;
