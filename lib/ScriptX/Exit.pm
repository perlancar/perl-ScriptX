package ScriptX::Exit;

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
        summary => 'exit() early',
        conf => {
            before => {
                summary => 'Exit before the first handler of this event',
                schema => ['str*'],
            },
            after => {
                summary => 'Exit after the last handler of this event',
                schema => ['str*'],
            },
            exit_code => {
                summary => 'Exit code',
                schema => ['uint*'],
                default => 0,
            },
        },
        conf_rels => {
            req_one => [qw/before after/],
        },
    };
}

sub new {
    my ($class, %args) = (shift, @_);
    $args{before} || $args{after} or die "Please specify before or after";
    $args{exit_code} ||= 0;
    $class->SUPER::new(%args);
}

sub activate {
    my $self = shift;

    if ($self->{before}) {
        ScriptX::add_handler(
            $self->{before},
            'Exit',
            0,
            sub { exit($self->{exit_code}) },
        );
    }
    if ($self->{after}) {
        ScriptX::add_handler(
            $self->{after},
            'Exit',
            100,
            sub { exit($self->{exit_code}) },
        );
    }
}

1;
# ABSTRACT:

=for Pod::Coverage ^(.+)$

=head1 SYNOPSIS

 use ScriptX Exit => {after => 'get_args']};


=head1 DESCRIPTION
