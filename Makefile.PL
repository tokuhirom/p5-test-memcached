use inc::Module::Install;
name 'Test-memcached';
all_from 'lib/Test/memcached.pm';

requires 'Any::Moose';
requires 'Test::TCP';
requires 'File::Which';

tests 't/*.t';
author_tests 'xt';

build_requires 'Test::More';
use_test_base;
auto_include;
WriteAll;
