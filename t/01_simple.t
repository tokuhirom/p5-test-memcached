use strict;
use warnings;
use Test::memcached;
use Test::More;

my $memcached = Test::memcached->new();
ok $memcached->pid, 'memcached: ' . $memcached->pid;
note $memcached->port;

my $sock = IO::Socket::INET->new(
		      PeerAddr => '127.0.0.1',
		      PeerPort => $memcached->port,
		      Proto => 'tcp',
) or die $!;
print $sock "version\r\n";
my $version = <$sock>;
like $version, qr/VERSION \d\.\d\.\d/;
note $version;

done_testing;
