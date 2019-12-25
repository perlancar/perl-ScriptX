package ScriptX::Noop;

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
        summary => 'A plugin that does nothing, for testing',
        description => <<'_',

This plugin does nothing useful. It is mostly for testing purposes.

It installs a handler for the `run` event, but simply logs an info message
"Hello ...".

_
        conf => {
            foo => {
                summary => 'Some useless configuration',
                schema => ['str*'],
            },
        },
    };
}

sub meta_on_run {
    +{
        prio => 90, # low
    };
}

sub on_run {
    my ($self, $stash) = @_;

    log_info "Hello from the Noop plugin";
    [200];
}

1;
# ABSTRACT:

=for Pod::Coverage ^(.+)$

=head1 SYNOPSIS

 use ScriptX 'Noop';

Another example:

 use ScriptX Noop => {foo => 'bar'};


=head1 DESCRIPTION
