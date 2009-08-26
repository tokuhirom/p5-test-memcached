use strict;
use warnings;
use Test::memcached;
use Test::More;
use Test::Requires 'Cache::Memcached';

my $memcached = Test::memcached->new();
ok $memcached->pid, 'memcached: ' . $memcached->pid;
note $memcached->port;

my $mc = Cache::Memcached->new({servers => ['127.0.0.1:'.$memcached->port]});
$mc->set('foo' => 'bar');
is $mc->get('foo'), 'bar', 'got!';

done_testing;
