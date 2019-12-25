#!perl

use strict;
use warnings;
use Test::Exception;
use Test::More 0.98;

use ScriptX ();

is_deeply([ScriptX::_env_to_imports('')], []);
is_deeply([ScriptX::_env_to_imports('-Foo')], ['Foo']);
is_deeply([ScriptX::_env_to_imports('-Foo,-Bar')], ['Foo', 'Bar']);
is_deeply([ScriptX::_env_to_imports('-Foo,x,y,z,a')], ['Foo'=>{x=>"y",z=>"a"}]);
is_deeply([ScriptX::_env_to_imports('-Foo,x,y,z,a,-Bar')], ['Foo'=>{x=>"y",z=>"a"}, 'Bar']);
dies_ok { ScriptX::_env_to_imports('Foo') };

done_testing;
