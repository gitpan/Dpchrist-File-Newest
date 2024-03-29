#######################################################################
# $Id: Makefile.PL,v 1.19 2010-12-21 04:37:15 dpchrist Exp $
#
# Copyright 2010 by David Paul Christensen dpchrist@holgerdanske.com
#
# This program is free software; you can redistribute it and/or modify
# it under the terms of the GNU General Public License as published by
# the Free Software Foundation; version 2.
#
# This program is distributed in the hope that it will be useful, but
# WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
# General Public License for more details.
#
# You should have received a copy of the GNU General Public License
# along with this program; if not, write to the Free Software
# Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA 02111-1307,
# USA.
#######################################################################

package Dpchrist::ExtUtils::MakeMaker;	# for symbols

use ExtUtils::MakeMaker;

eval "use Test::Manifest";
warn $@ if $@;

eval {
    require Dpchrist::ExtUtils::MakeMaker;
    die 'Skipping Dpchrist::ExtUtils::MakeMaker'
    	unless 1.027 <= $Dpchrist::ExtUtils::MakeMaker::VERSION;
    import  Dpchrist::ExtUtils::MakeMaker (
	postamble => sub {
	    my ($o, $prev) = @_;
	    return join('',
		$prev,
		mcpani  ($o, $ENV{CPAN_AUTHORID}),
		pod2html($o, qw( lib/Dpchrist/File/Newest.pm
				 perl-bin/newest )),
		readme  ($o, 'lib/Dpchrist/File/Newest.pm'),
		release ($o, $ENV{RELEASE_ROOT}),
	    );
	},
    );
};
warn $@ if $@;

WriteMakefile(
    NAME		=> 'Dpchrist::File::Newest',
    VERSION_FROM	=> 'lib/Dpchrist/File/Newest.pm',
    PREREQ_PM		=> {
	Carp			=> 1.08,
	Cwd			=> 3.2501,
	Data::Dumper		=> 2.121_14,
	Dpchrist::Debug		=> 1.049,
	Exporter		=> 5.62,
	ExtUtils::MakeMaker	=> 6.54,
	File::Find		=> 1.12,
	File::Spec::Functions	=> 3.2501,
	Getopt::Long		=> 2.37,
	Pod::Usage		=> 1.35,
	Test::Compile		=> 0.10,
	Test::Manifest		=> 1.22,
	Test::More		=> 0.72,
	Test::Pod		=> 1.40,
	Test::Prereq		=> 1.037,
    },
    AUTHOR		=>
    	'David Paul Christensen <dpchrist@holgerdanske.com>',
    EXE_FILES           => ['./perl-bin/newest'],
    clean		=> {
	FILES => q( *~tmp */*~tmp *.tar debug.log ),
    },
    realclean		=> {
	FILES => q( README *.html *.tar.gz ),
    },
);

#######################################################################
