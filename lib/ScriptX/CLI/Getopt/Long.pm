package ScriptX::CLI::Getopt::Long;

use parent 'ScriptX::Base';

sub new {
    my ($class, %args) = (shift, @_);
    $args{spec} or die "Please supply spec";
    $class->SUPER::new(%args);
}

sub on_get_args {
    my ($self, $stash) = @_;

    require Getopt::Long;
    my $res = Getopt::Long::GetOptions(@{ $self->{spec} });
    $res ? [200] : [500, "GetOptions failed"];
}

1;
# ABSTRACT: Getopt::Long for CLI scripts
