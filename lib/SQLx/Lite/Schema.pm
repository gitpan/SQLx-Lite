package SQLx::Lite::Schema;

use base 'SQLx::Lite::ResultSet';

sub resultset {
    my ($self, $table) = @_;

    $self->{resultset} = { table => $table, dbh => $self->{dbh} };
    bless $self->{resultset}, 'SQLx::Lite::ResultSet';
}

1;
