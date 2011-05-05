use strict;
use warnings;
package App::Whatsit;

# ABSTRACT: Easily find out package details from the command line.

use base qw(App::Cmd::Simple)

sub validate_args
{
	my $self = shift;
	my $options = shift;
	my $args = shift;
	
	$self->usage_error("At least one package name is required") unless @$args;
}

sub execute
{
	my $self = shift;
	my $options = shift;
	my $args = shift;
	
	foreach (@$args)
	{
		find_details($_);
	}
}

sub find_details
{
	my $packagee = shift;
	
	eval "use $package";
	if($@)
	{
		# TODO bail out (completely)
	}
	else
	{
		my $version = $package->VERSION;
		$version = 'Unknown' unless defined $version;
		
		my $package_file = $package.'.pm';
		$package_file =~ s/::/\//g;
		my $path = $INC{$package_file};
		$path = 'Unknown' unless defined $path;
		
		print "$package:\n\tVersion: $version\n\tPath: $path";
	}
}

1;
