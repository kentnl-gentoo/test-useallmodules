use ExtUtils::MakeMaker;
WriteMakefile(
    NAME              => 'Test::UseAllModules',
    VERSION_FROM      => 'lib/Test/UseAllModules.pm',
    PREREQ_PM         => { 'Test::More' => 0},
    ($] >= 5.005 ?
      (ABSTRACT_FROM  => 'lib/Test/UseAllModules.pm',
       AUTHOR         => 'Kenichi Ishigaki <ishigaki@cpan.org>') : ()),
);
