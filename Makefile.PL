use 5.008000;
use ExtUtils::MakeMaker;
WriteMakefile(
    NAME		=> 'Dpchrist::File::Newest',
    VERSION_FROM	=> 'bin/newest',
    PREREQ_PM		=> {},
    AUTHOR		=>
    	'David Christensen <dpchrist@holgerdanske.com>',
    EXE_FILES           => ['./bin/newest'],
);
