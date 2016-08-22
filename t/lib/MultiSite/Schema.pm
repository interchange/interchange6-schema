package MultiSite::Schema;

use base 'Interchange6::Schema';

Interchange6::Schema->load_own_components('MultiSite');

__PACKAGE__->multisite_config( { foo => 'bar' } );

__PACKAGE__->load_namespaces();

1;
