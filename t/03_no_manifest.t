use strict;
use Test::UseAllModules;

BEGIN {
  chdir 't/NoMANIFEST';
  all_uses_ok();
  chdir '../..';
}

