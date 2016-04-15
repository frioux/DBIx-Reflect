package DBIx::Reflect;

use Moo;

has _introspector => (
  is => 'ro',
  builder => sub {
    my $i = DBIx::Introspector->new(drivers => '2013-12.01');


    $i->decorate_driver_unconnected(Pg     => concat_sql => '? || ?');
    $i->decorate_driver_unconnected(SQLite => concat_sql => '? || ?');
    $i->decorate_driver_unconnected(MSSQL  => concat_sql => '? + ?');
    $i->decorate_driver_unconnected(mysql  => concat_sql => 'CONCAT( ?, ? )');


    return $i;
  },
  handles => {
    _get_i => 'get',
  },
);

sub _get_i {
  my ($self, $dbh, $dsn, $fact) = @_;

  $self->_introspector->get(
    $dbh || $self->_dbh,
    $dsn || $self->_dsn,
    $fact,
  )
}

has _dbh => ( is => 'ro' );

has _dsn => ( is => 'ro' );

sub concat_sql { shift->_get_i(@_, 'concat_sql') }

# dateop stuff

# generics (DB name, version, etc)

1;
