package getaddress;

use 5.006005;
use strict;
use warnings;
use Carp;

require Exporter;
use AutoLoader;

our @ISA = qw(Exporter);

# Items to export into callers namespace by default. Note: do not export
# names by default without a very good reason. Use EXPORT_OK instead.
# Do not simply export all your public functions/methods/constants.

# This allows declaration	use getaddress ':all';
# If you do not need this, moving things directly into @EXPORT or @EXPORT_OK
# will save memory.
our %EXPORT_TAGS = ( 'all' => [ qw(
	
) ] );

our @EXPORT_OK = ( @{ $EXPORT_TAGS{'all'} } );

our @EXPORT = qw(
	ipwhere
);

our $VERSION = '0.01';

sub AUTOLOAD {
    # This AUTOLOAD is used to 'autoload' constants from the constant()
    # XS function.

    my $constname;
    our $AUTOLOAD;
    ($constname = $AUTOLOAD) =~ s/.*:://;
    croak "&getaddress::constant not defined" if $constname eq 'constant';
    my ($error, $val) = constant($constname);
    if ($error) { croak $error; }
    {
	no strict 'refs';
	# Fixed between 5.005_53 and 5.005_61
#XXX	if ($] >= 5.00561) {
#XXX	    *$AUTOLOAD = sub () { $val };
#XXX	}
#XXX	else {
	    *$AUTOLOAD = sub { $val };
#XXX	}
    }
    goto &$AUTOLOAD;
}

require XSLoader;
XSLoader::load('getaddress', $VERSION);

# Preloaded methods go here.
sub ipwhere
{
	my $ip = shift;
	my $ipfile = shift;
	$ipfile = "data/QQWry.Dat" unless ($ipfile);
	my $ipaddr = getipwhere ($ipfile, $ip);
	return '未知地区' unless ($ipaddr);
	$ipaddr =~ s/CZ88\.NET//ig;
	$ipaddr =~ s/^\s*//;
	$ipaddr =~ s/\s*$//;
	$ipaddr = '未知地区' if (!$ipaddr || $ipaddr =~ /未知|http/i);
	return $ipaddr;
}

1;

__END__

=head1 NAME

getaddress - Get Address From IP

=head1 SYNOPSIS

You can do this:

=over 

  use getaddress;
  print &ipwhere ('192.168.1.1', $path . '/QQWry.Dat');

=back

=head1 DESCRIPTION

You can use C<getaddress> to get address for your applications, it is very faster than common, you can find common.pl and getaddress.pl to compare in directory F<./bin/>.

=head1 SEE ALSO

You can find:

    http://my.huhoo.net/archives/2008/02/perl_ip.html
    http://my.huhoo.net/archives/2008/02/php_ip.html

=head1 AUTHOR

Cnangel Li, E<lt>lijunlia@alibaba-inc.comE<gt>

=head1 COPYRIGHT AND LICENSE

Copyright (C) 2008-2009 by Cnangel Li(cnangel)

This library is free software; you can redistribute it and/or modify
it under the same terms as Perl itself, either Perl version 5.8.5 or,
at your option, any later version of Perl 5 you may have available.

=cut
