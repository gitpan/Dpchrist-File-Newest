#######################################################################
# $Id: Newest.pm,v 1.24 2010-11-25 02:29:41 dpchrist Exp $
#######################################################################
# package:
#----------------------------------------------------------------------

package Dpchrist::File::Newest;

use strict;
use warnings;

require Exporter;

our @ISA = qw(Exporter);

our %EXPORT_TAGS = ( 'all' => [ qw(
    newest
) ] );

our @EXPORT_OK	= ( @{ $EXPORT_TAGS{'all'} } );

our @EXPORT	= qw();

our $VERSION	= sprintf "%d.%03d", q$Revision: 1.24 $ =~ /(\d+)/g;

#######################################################################
# uses:
#----------------------------------------------------------------------

use constant			DEBUG => 0;

use Carp;
use Cwd;
use Data::Dumper;
use Dpchrist::Debug             qw( :all );
use File::Find;
use File::Spec::Functions	qw( rel2abs );

#######################################################################
# globals:
#----------------------------------------------------------------------

our %mtimes_paths;		# key is file mtime
				# value is a reference to a list
				# containing file paths

our %opt = (			# options
    -number		=> 1,
);

#######################################################################

=head1 NAME

Dpchrist::File::Newest - find newest files


=head1 DESCRIPTION

=cut

#######################################################################
# private subroutines:
#----------------------------------------------------------------------

sub _wanted
{
    dprint('cwd =', cwd()) if DEBUG;

    my $path = $File::Find::name;

    my $file = $_;

    ddump([$path, $file], [qw(path file)]) if DEBUG;

    goto DONE if -d $file;
    
    my @stat = stat($file);

    confess "failed calling stat() on path '$path': $!"
	unless @stat;

    my $mtime = $stat[9];

    ddump([$mtime], [qw(mtime)]) if DEBUG;

    push(@{$mtimes_paths{$mtime}}, $path);

  DONE:

    dprint 'returning' if DEBUG;
}

#######################################################################

=head2 SUBROUTINES

=head3 newest

    newest LIST

Recursively searches all files and folders given by PATH
and returns a reference to an array of paths
sorted from oldest to newest.

Calls Carp::confess() on error.

=cut

#----------------------------------------------------------------------
    
sub newest
{
    ddump('entry', [\@_], [qw(*_)]) if DEBUG;


    ### process arguments:

    confess 'Required argument LIST missing' unless 0 < @_;

    foreach (@_) {
	confess "Path '$_' does not exist" unless -e $_;
    }


    ### gather mtime and path information:

    find(\&_wanted, @_);

    ddump([\%mtimes_paths], [qw(*mtimes_paths)]) if DEBUG;

    
    ### create sorted list of mtime's:

    my @mtimes = sort keys %mtimes_paths;

    ddump([\@mtimes], [qw(*mtimes)]) if DEBUG;


    ### create list of paths sorted by mtime's:

    my @retval;

    foreach my $mtime (sort {$a <=> $b} keys %mtimes_paths) {
	ddump([$mtime], [qw(mtime)]) if DEBUG;

	foreach my $path (sort @{$mtimes_paths{$mtime}}) {
	    ddump([$path], [qw(path)]) if DEBUG;
	    push @retval, $path;
	}
    }


    ### done:

    ddump('returning', [\@retval], [qw(*retval)]) if DEBUG;
    return \@retval;
}

#######################################################################
# end of code:
#----------------------------------------------------------------------

1;
__END__

#######################################################################

=head2 EXPORT

None by default.

All of the subroutines may be imported by using the ':all' tag:

    use Dpchrist::File::Newest    qw( :all );

See 'perldoc Export' for everything in between.


=head1 INSTALLATION

    perl Makefile.PL
    make
    make test
    make install


=head1 DEPENDENCIES

    Perl 5.10
    Dpchrist::Debug
    Dpchrist::Module


=head1 SEE ALSO

    newest(1)
    stat(1)


=head1 AUTHOR

David Paul Christensen  dpchrist@holgerdanske.com


=head1 COPYRIGHT AND LICENSE

Copyright 2010 by David Paul Christensen dpchrist@holgerdanske.com

This program is free software; you can redistribute it and/or modify
it under the terms of the GNU General Public License as published by
the Free Software Foundation; version 2.

This program is distributed in the hope that it will be useful, but
WITHOUT ANY WARRANTY; without even the implied warranty of
MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
General Public License for more details.

You should have received a copy of the GNU General Public License
along with this program; if not, write to the Free Software
Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA 02111-1307,
USA.

=cut

#######################################################################
