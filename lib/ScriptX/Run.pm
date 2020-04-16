package ScriptX::Run;

# AUTHORITY
# DATE
# DIST
# VERSION

use strict;
use Log::ger;

use parent 'ScriptX::Base';
require ScriptX;

sub meta {
    return {
        summary => "Run something at the 'run' event",
        description => <<'_',

You can give this plugin a coderef (`code`), or a command (`command`). Or you
can also defined `run()` in your `main` package.

_
        conf => {
            code => {
                schema => 'code*',
                description => <<'_',

Code will get the plugin's instance as the first argument and stash as the
second:

    ($self, $stash)

_
            },
            command => {
                schema => ['any*', of=>['str*', 'array*']],
                description => <<'_',

Will be run using <pm:IPC::System::Options>'s `system`.

_
            },
        },
        conf_rels => {
            choose_one => ['conf', 'command'],
        },
    };
}

sub on_run {
    my ($self, $stash) = @_;

    if (my $code = $self->{code}) {
        log_trace "Running code";
        $code->($self, $stash);
    } elsif (defined(my $command = $self->{command})) {
        log_trace "Running command";
        require IPC::System::Options;
        IPC::System::Options::system(
            ref $command eq 'ARRAY' ? @$command : $command);
    } elsif (defined &{"main::run"}) {
        log_trace "Running main::run()";
        main::run($self, $stash);
    } else {
        die "Don't know what to run. Give me 'code', or 'command', ".
            "or define main::run().";
    }

    [200];
}

1;
# ABSTRACT:

=head1 DESCRIPTION
