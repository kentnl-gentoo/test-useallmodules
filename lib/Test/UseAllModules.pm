package Test::UseAllModules;

use strict;
use warnings;
use ExtUtils::Manifest qw( maniread );

our $VERSION = '0.09';

use Exporter;

our @ISA = qw/Exporter/;
our @EXPORT = qw/all_uses_ok/;

use Test::More;

sub all_uses_ok {
  shift if @_ && $_[0] eq 'except';

  my @exceptions = @_;
  my @modules;

  unless (-f 'MANIFEST') {
    plan skip_all => 'no MANIFEST';
    exit;
  }

  my $manifest = maniread();

READ:
  foreach my $file (keys %{ $manifest }) {
    if (my ($module) = $file =~ m|^lib/(.*)\.pm\s*$|) {
      $module =~ s|/|::|g;

      foreach my $rule (@exceptions) {
        next READ if $module eq $rule || $module =~ /$rule/;
      }

      push @modules, $module;
    }
  }

  unless (@modules) {
    plan skip_all => 'no .pm files are found under the lib directory';
    exit;
  }
  plan tests => scalar @modules;

  my @failed;
  foreach my $module (@modules) {
    use_ok($module) or push @failed, $module;
  }

  BAIL_OUT( 'failed: ' . (join ',', @failed) ) if @failed;
}

1;
__END__

=head1 NAME

Test::UseAllModules - do use_ok() for all modules MANIFESTed

=head1 SYNOPSIS

  # basic use
  use strict;
  use Test::UseAllModules;

  BEGIN { all_uses_ok(); }

  # if you have modules that'll fail use_ok() for themselves
  use strict;
  use Test::UseAllModules;

  BEGIN {
    all_uses_ok except => qw(
      Some::Dependent::Module
      Another::Dependent::Module
      ^Yet::Another::Dependent::.*   # you can use regex
    )
  }

=head1 DESCRIPTION

I'm sick of writing 00_load.t (or something like that) that'll do
use_ok() for every module I write. I'm sicker of updating 00_load.t
when I add another file to the distro. This module reads MANIFEST to
find modules to be tested and does use_ok() for each of them.
Now all you have to do is updating MANIFEST. You don't have to
modify the test any more (hopefully).

=head1 EXPORTED FUNCTIONS

=head2 all_uses_ok

Does Test::More's use_ok() for every module found in MANIFEST.
Tests only modules under 'lib/' directory. If you have modules
you don't want to test, give the module name(s) or regex rule
for the argument. The word 'except' will be ignored as shown
above.

=head1 NOTES

As of 0.03, this module calls BAIL_OUT of Test::More if any of
the use_ok tests should fail. (Thus the following tests will be
ignored. Missing or unloadable modules cause a lot of errors of
the same kind.)

=head1 SEE ALSO

L<Test::More>

=head1 AUTHOR

Kenichi Ishigaki, E<lt>ishigaki@cpan.orgE<gt>

=head1 COPYRIGHT AND LICENSE

Copyright (C) 2006 by Kenichi Ishigaki

This library is free software; you can redistribute it and/or modify
it under the same terms as Perl itself.

=cut
