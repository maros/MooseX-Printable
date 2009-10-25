# ============================================================================
package MooseX::Printable;
# ============================================================================
use utf8;
use 5.0100;

use Moose::Role;
use MooseX::Printable::Meta::Attribute::Trait::Printable;
use warnings;

sub print_object {
    my ($self) = @_;
    
    my @output;
    
    # Loop all attributes
    foreach my $attribute ($self->meta->get_all_attributes) {
        # Filter attributes
        next 
            unless $attribute->does('Printable');
        
        # Fetch value (has_value does not work with lazy attributes)
        my $value;
        if ($attribute->has_printer) {
            $value = $attribute->printer->($self);
        } else {
            $value = $attribute->get_value($self);
        }
        
        # Label
        my $label;
        $label = $attribute->label
            if $attribute->has_label;
        $label ||= $attribute->documentation()
            if $attribute->has_documentation;
        $label ||= $attribute->name;
        
        my @return = $self->print_value(
            value   => $value,
            label   => $label,
        );
        
        push (@output,@return)
            if scalar @return;
    }
    
    return \@output;
}

sub print_value {
    my ($self,%params) = @_;
    
    my $output = [];
    my $value = $params{value};
    
    my $return = \%params;
    
    # Skip empty values
    return
        if (! defined $value || $value eq '');
    
    given (ref $value) {
        when('') {
            return $return;
        }
        when('ARRAY') {
            my $index = 1;
            my @output;
            my $index_prefix = defined $return->{index} ?
                $return->{index} .'.' : '';
            foreach my $element (@$value) {
                my @return = $self->print_value(
                    value   => $element,
                    label   => $return->{label},
                    index   => $index_prefix.$index,
                );
                push (@output,@return);
                $index ++;
            }
            return @output;
        }
        when('HASH') {
            my @output;
            my $index_prefix = defined $return->{index} ?
                $return->{index} .'.' : '';
            foreach my $key (sort keys %$value) {
                my @return = $self->print_value(
                    value   => $value->{$key},
                    label   => $return->{label},
                    index   => $index_prefix.$key,
                );
                push (@output,@return);
            }
            return @output;
        }
        when(['CODE','IO','GLOB','FORMAT']) {
            warn('Cannot print $_');
        }
        # Some object 
        default {
            if ($value->can('meta')
                && $value->meta->does_role('MooseX::Printable')
                && $value->can('print_object')) {
                #$return->{value} = $value->print_object();
                $return->{value} = $value;
                return $return;
            } elsif ($value->can('print_object')) {
                return $self->print_value(
                    value   => $value->print_object(),
                    label   => $return->{label},
                );
            } else {
                return $return;
            }
        }
    }
}


1;