package ScriptX::CLI;

use parent 'ScriptX::Base';
require ScriptX;

sub new {
    my ($class, %args) = (shift, @_);
    $class->SUPER::new(%args);
}

sub on_run {
    my ($self, $stash) = @_;

    ScriptX::run_event(
        name => 'get_args',
    );

    main::run() if defined &main::run;

    [200];
}

1;
# ABSTRACT: CLI scripts
