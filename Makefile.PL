use ExtUtils::MakeMaker;
# See lib/ExtUtils/MakeMaker.pm for details of how to influence
# the contents of the Makefile that is written.
WriteMakefile(
    'NAME'	=> 'Set::IntegerFast',
    'DISTNAME'  => 'Set-IntegerFast',
    'VERSION'	=> '1.0',
    'OBJECT'	=> '$(O_FILES)',
    'LIBS'	=> [''],   # e.g., '-lm' 
    'DEFINE'	=> '',     # e.g., '-DHAVE_SOMETHING' 
    'INC'	=> '',     # e.g., '-I/usr/include/other' 
    'dist'      => { COMPRESS=>"gzip", SUFFIX=>"gz" }
);
