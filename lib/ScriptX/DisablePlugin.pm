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

sub meta {
    return {
        summary => 'Prevent the loading (activation) of other plugins',
        conf => {
            plugins => {
                summary => 'List of plugin names or regexes',
                description => <<'_',

Plugins should be an array of plugin names or regexes, e.g.:

    ['Foo', 'Bar', qr/baz/]

To make it easier to specify via environment variable (SCRIPTX_IMPORT), a
semicolon-separated string is also accepted. A regex should be enclosed in
"/.../". For example:

    Foo;Bar;/baz/

_
                schema => ['any*', of=>[
                    'str*',
                    ['array*', of=>['any*', of=>['str*', 're*']]],
                ]],
                req => 1,
            },
        },
    };
}

sub new {
    my ($class, %args) = (shift, @_);
    $args{plugins} or die "Please specify plugins to disable";
    unless (ref $args{plugins} eq 'ARRAY') {
        $args{plugins} =
            [map { m!\A/(.*)/\z! ? qr/$1/ : $_ } split /;/, $args{plugins}];
    }
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
        log_info "[ScriptX::DisablePlugin] Disabling loading of ScriptX plugin '$stash->{plugin_name}'";
        return [601, "Cancel"];
    }
    [200, "OK"];
}

1;
# ABSTRACT:

=for Pod::Coverage ^(.+)$

=head1 SYNOPSIS

 use ScriptX DisablePlugin => {plugins => ['Foo', qr/^Bar/]};


=head1 DESCRIPTION
