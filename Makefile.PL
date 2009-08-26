use inc::Module::Install;
name 'Test-memcached';
all_from 'lib/Test/memcached.pm';

# requires '';

tests 't/*.t';
author_tests 'xt';

build_requires 'Test::More';
use_test_base;
auto_include;
WriteAll;
