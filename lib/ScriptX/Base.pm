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
    my ($self, $wanted_event, $wanted_prio) = @_;

    my $pkg = ref($self);
    my $symtbl = \%{$pkg . "::"};

    (my $plugin_name = $pkg) =~ s/\AScriptX:://;

    my $meta;
  CHECK_META: {
        defined &{"$pkg\::meta"} or die "$pkg does not define meta()";
        $meta = &{"$pkg\::meta"}();
        my $v = $meta->{v}; $v = 1 unless defined $v;
        if ($v != 1) {
            die "Cannot use $pkg: meta: I only support v=1 ".
                "but the module has v=$v";
        }
    }

    # register in %Plugins
    $ScriptX::Plugins{$plugin_name} = $self;

    for my $k (keys %$symtbl) {
        my $v = $symtbl->{$k};
        next unless ref $v eq 'CODE' || defined *$v{CODE};
        next unless $k =~ /^(before_|on_|after_)(.+)$/;

        my $meta_method = "meta_$k";
        my $meta = $self->can($meta_method) ? $self->$meta_method : {};

        (my $event = $k) =~ s/^on_//;

        ScriptX::add_handler(
            defined $wanted_event ? $wanted_event : $event,
            $plugin_name,
            defined $wanted_prio ? $wanted_prio :
                (defined $meta->{prio} ? $meta->{prio} : 50),
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
