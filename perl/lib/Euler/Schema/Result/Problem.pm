package Euler::Schema::Result::Problem;

use base qw(DBIx::Class::Core);

__PACKAGE__->table('problems');
__PACKAGE__->add_columns(
        id => {
            accessor => 'id',
            data_type => 'integer',
            is_nullable => 0,
            is_auto_increment => 1,
        },
        name => {
            accessor => 'name',
            data_type => 'varchar',
            is_nullable => 0,
            is_auto_increment => 0,
        },
        text => {
            accessor => 'text',
            data_type => 'blob',
            is_nullable => 0,
            is_auto_increment => 0,

        },
        solution => {
            accessor => 'name',
            data_type => 'varchar',
            is_nullable => 1,
            is_auto_increment => 0,

        },
);

__PACKAGE__->set_primary_key('id');

1;

