use Test::More tests => 1;

ok((system 'perl -c bin/newest') == 0);
