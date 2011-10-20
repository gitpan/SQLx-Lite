use SQLx::Lite;
use 5.010;

my $dbh = SQLx::Lite->new(
    dbi => 'SQLite:test.db',
)->connect;

my $res = $dbh->resultset('users')->search([], { user => 'brad' });

say $res->count;

for my $row (@{$res->result}) {
    say $row->{user};
}
