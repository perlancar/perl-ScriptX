package ScriptX::Debug::DumpStash;

# AUTHORITY
# DATE
# DIST
# VERSION

use parent 'ScriptX::Base';

sub meta {
    return {
    };
}

sub meta_before_run { +{prio=>99} }
sub before_run {
    my ($self, $stash) = @_;
    {
        eval { require Data::Dump::Color; Data::Dump::Color::dd($stash) };
        last unless $@;
        eval { require Data::Dump; Data::Dump::dd($stash) };
        last unless $@;
        require Data::Dumper; print Data::Dumper->new([$stash], ["stash"])->Purity(1)->Dump;
    }
    [200, "OK"];
}

1;
# ABSTRACT: Dump stash

=for Pod::Coverage ^(.+)$

=head1 DESCRIPTION

By default, stash is dumped right before run (event C<before_run>, prio 99). You
can dump at other events using the import syntax:

 use ScriptX 'Debug::DumpStash@after_run';
 use ScriptX 'Debug::DumpStash@after_run@99';

on the command-line perl option:

 -MScriptX=-Debug::DumpStash@after_run
 -MScriptX=-Debug::DumpStash@after_run@99
