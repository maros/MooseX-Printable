#!perl

use Test::NoWarnings;
use Test::Most tests => 16 + 1;

use lib qw(t/);

{
    package Testapp;
    use Moose;
    with qw(MooseX::Printable::Table);
    
    has 'attribute1'    => (
        is              => 'rw',
        label           => '1st attribute',
        documentation   => 'attribute with the index 1',
        traits           => ['Printable'],
    );
    
    has 'attribute2'    => (
        is              => 'rw',
        documentation   => '2nd attribute',
        traits           => ['Printable'],
    );
    
    has 'attribute3'    => (
        is              => 'rw',
        documentation   => '3rd attribute',
    );
    
    has 'attribute4'    => (
        is              => 'rw',
        traits           => ['Printable'],
    );
}

{
    package Testapp2;
    use Moose;
    with qw(MooseX::Printable::Table);
    
    has 'other_attribute1'    => (
        is              => 'rw',
        traits           => ['Printable'],
    );
    
    has 'other_attribute2'    => (
        is              => 'rw',
        traits           => ['Printable'],
    );
}


{
    my $t1 = Testapp->new(
        attribute1  => 'value1',
        attribute2  => 'value2',
        attribute3  => 'value3',
        attribute4  => 'value4',
    );
    
    #explain($t1->print_object);
    
    my $t2 = Testapp->new(
        attribute1  => undef,
        attribute2  => ['value2.1','value2.2','value2.3'],
        attribute3  => 'value3',
        attribute4  => {
            key1        => 'value4.1',
            key2        => 'value4.2',
            key3        => 'value4.3',
        },
    );
    
    #explain($t2->print_object);
    
    my $t3 = Testapp->new(
        attribute1  => Testapp2->new(
            other_attribute1    => 1,
            other_attribute2    => 2,
        ),
        attribute2  => ['value2.1','value2.2','value2.3'],
        attribute3  => 'value3',
        attribute4  => {
            key1        => ['value4.1.1','value4.1.2','value4.1.3'],
            key2        => 'value4.2',
            key3        => 'value4.3',
        },
    );
    
    explain($t3->print_object);
    
    print $t3->print_table->draw
}
