package ScriptX::Getopt::Long;

use parent 'ScriptX::Base';

sub meta {
    return {
        summary => 'Get options using Getop::Long',
        conf => {
            spec => {
                summary => "Specification to be passed to Getopt::Long's GetOptions",
                schema => 'array*',
                req => 1,
            },
        },
    };
}

sub before_run {
    my ($self, $stash) = @_;

    require Getopt::Long;
    Getopt::Long::Configure("gnu_getopt", "no_ignore_case");
    my $res = Getopt::Long::GetOptions(@{ $self->{spec} });
    $res ? [200] : [500, "GetOptions failed"];
}

1;
# ABSTRACT: Parse command-line options using Getopt::Long

=head1 SYNOPSIS

 use ScriptX::Getopt::Long => {
     spec => [
         'foo=s' => sub { ... },
         'bar'   => sub { ... },
     ],
 };


=head1 DESCRIPTION

This plugin basically just configures L<Getopt::Long>:

 Getopt::Long::Configure("gnu_getopt", "no_ignore_case");

then pass the spec to C<GetOptions()>.


=head1 SEE ALSO

L<Getopt::Long>

L<ScriptX::Getopt::Specless>
