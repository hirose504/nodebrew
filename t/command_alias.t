use strict;
use warnings;

use t::Util;
use Test::More;

my $nodebrew = init_nodebrew();
$nodebrew->run('setup');
$nodebrew->run('install', ['v0.6.0']);
$nodebrew->run('install', ['v0.6.1']);

ok !-e "$nodebrew->{alias_file}";
is $nodebrew->run('alias', ['foo', 'bar']), "foo -> bar\n";
ok -e "$nodebrew->{alias_file}";
is $nodebrew->run('alias'), "foo -> bar\n";

is $nodebrew->run('alias', ['hoge', 'fuga']), "hoge -> fuga\n";
is $nodebrew->run('alias'), "foo -> bar\nhoge -> fuga\n";

is $nodebrew->run('alias', ['foo', 'baz']), "foo -> baz\n";
is $nodebrew->run('alias'), "foo -> baz\nhoge -> fuga\n";

is $nodebrew->run('alias', ['baz']), "baz is not set alias\n";
is $nodebrew->run('alias', ['foo']), "foo -> baz\n";

$nodebrew->run('alias', ['foo', 'v0.6.0']);
$nodebrew->run('use', ['foo']);
like $nodebrew->run('list'), qr/current: v0.6.0/;

$nodebrew->run('alias', ['0.6', '0.6.x']);
$nodebrew->run('use', ['0.6']);
like $nodebrew->run('list'), qr/current: v0.6.1/;

is $nodebrew->run('unalias', ['foo']), "remove foo\n";
is $nodebrew->run('alias'), "0.6 -> 0.6.x\nhoge -> fuga\n";

is $nodebrew->run('unalias', ['foo']), "foo is not defined\n";

done_testing;
