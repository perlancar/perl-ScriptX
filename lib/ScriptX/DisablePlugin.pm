package ScriptX::DisablePlugin;

# AUTHORITY
# DATE
# DIST
# VERSION

# IFUNBUILT
use strict;
use warnings;
# END IFUNBUILT
use Log::ger;

use parent 'ScriptX::Base';
require ScriptX;

sub meta {
    return {
        summary => 'Prevent the loading (activation) of other plugins',
        conf => {
            plugins => {
                summary => 'List of plugin names or regexes',
                schema => ['array*', of=>['any*', of=>['str*', 're*']]],
                req => 1,
            },
        },
    };
}

sub new {
    my ($class, %args) = (shift, @_);
    $args{plugins} or die "Please specify plugins to disable";
    $class->SUPER::new(%args);
}

sub before_activate_plugin {
    my ($self, $stash) = @_;

    for my $el (@{ $self->{plugins} }) {
        if (ref $el eq 'Regexp') {
            next unless $stash->{plugin_name} =~ $el;
        } else {
            next unless $stash->{plugin_name} eq $el;
        }
        log_info "NOT loading ScriptX plugin '$stash->{plugin_name}' (disabled by DisablePlugin)";
        return [412];
    }
    [200];
}

1;
# ABSTRACT:

=for Pod::Coverage ^(.+)$

=head1 SYNOPSIS

 use ScriptX DisablePlugin => {plugins => ['CLI::Log', qr/Foo/]};


=head1 DESCRIPTION
