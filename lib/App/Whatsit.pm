use strict;
use warnings;
package App::Whatsit;

# ABSTRACT: Easily find out package details from the command line.

use base qw(App::Cmd::Simple);

=head1 SYNOPSIS

  $ whatsit [package name]

  $ whatsit -p [package name]

=head2 Path only

Sending in the -p flag will give you the path to the current module.
Suitable for use in pipes or backticks:

    $ emacs `whatsit -p Catalyt::Request Catalyst::Response`

=cut

my $path_only = 0;

sub validate_args
{
	my $self = shift;
	my $options = shift;
	my $args = shift;

	$path_only = grep { $_ =~ /^-(?:-)?p(?:ath)?/ } @$args;
	my $no_args = $path_only ? scalar(@$args) == 1 : @$args;
	$self->usage_error("At least one package name is required") if $no_args;

}

sub execute
{
	my $self = shift;
	my $options = shift;
	my $args = shift;
	
	foreach (@$args)
	{
		next if $_ =~ /^-/;
		_find_details($_);
	}
}

sub _find_details
{
	my $package = shift;
	
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
		print $path_only ? "$path "
		  : "$package:\n\tVersion: $version\n\tPath: $path\n";
	}
}

1;
