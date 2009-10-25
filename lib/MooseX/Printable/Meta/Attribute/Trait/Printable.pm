# ============================================================================
package MooseX::Printable::Meta::Attribute::Trait::Printable;
# ============================================================================
use utf8;
use 5.0100;

use Moose::Role;
use warnings; # make cpants happy

has 'printer' => (
    is          => 'rw',
    isa         => 'CodeRef',
    predicate   => 'has_printer',
);

has 'label' => (
    is          => 'rw',
    isa         => 'Str',
    predicate   => 'has_label',
);

package Moose::Meta::Attribute::Custom::Trait::Printable;
sub register_implementation { 'MooseX::Printable::Meta::Attribute::Trait::Printable' }

1;