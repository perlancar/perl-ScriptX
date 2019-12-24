package ScriptX::Base;

# AUTHORITY
# DATE
# DIST
# VERSION

# IFUNBUILT
use strict 'subs', 'vars';
use warnings;
# END IFUNBUILT

require ScriptX;

sub new {
    my ($class, %args) = (shift, @_);
    bless \%args, $class;
}

sub activate {
    my $self = shift;

    my $pkg = ref($self);
    my $symtbl = \%{$pkg . "::"};

    for my $k (keys %$symtbl) {
        my $v = $symtbl->{$k};
        next if $k =~ /::$/; # subpackage
        next unless defined *$v{CODE}; # subroutine
        next unless $k =~ /^(before_|on_|after_)(.+)$/;

        my $meta_method = "meta_$k";
        my $meta = $self->can($meta_method) ? $self->$meta_method : {};

        (my $event = $k) =~ s/^on_//;

        ScriptX::add_handler(
            $event,
            $pkg,
            defined $meta->{prio} ? $meta->{prio} : 50,
            sub {
                my $stash = shift;
                $self->$k($stash);
            },
        );
    }
}

1;
# ABSTRACT: Base class for ScriptX plugin

=for Pod::Coverage ^(.+)$

=head1 DESCRIPTION

This base class allows you to write handlers as methods with names
/^(before_|on_|after_)EVENT_NAME$/ and metadata like priority in the
/^meta_HANDLER/ method.
