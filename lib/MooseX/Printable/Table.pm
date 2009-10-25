# ============================================================================
package MooseX::Printable::Table;
# ============================================================================
use utf8;
use 5.0100;

use Moose::Role;
with qw(MooseX::Printable);
 
use Text::SimpleTable;

sub print_table {
    my ($self,$table) = @_;
    
    $table ||= Text::SimpleTable->new(20,12,40);
    
    my $return = $self->print_object();
    
    foreach my $line (@$return) {
        if (ref $line->{value}) {
            $table->row($line->{label},$line->{index}||'','');
            $table->hr();
            $line->{value}->print_table($table);
            $table->hr();
        } else {
            $table->row($line->{label},$line->{index}||'',$line->{value});
        }
    }
    
    return $table;
}


1;