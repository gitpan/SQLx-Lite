use inc::Module::Install;

name     'SQLx-Lite';
all_from 'lib/SQLx/Lite.pm';
author   q{Brad Haywood <brad@geeksware.net>};
license  'perl';

build_requires 'Test::More';

auto_install;

WriteAll;

