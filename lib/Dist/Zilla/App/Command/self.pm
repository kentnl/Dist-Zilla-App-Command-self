use strict;
use warnings;

package Dist::Zilla::App::Command::self;
$Dist::Zilla::App::Command::self::VERSION = '0.001000';
# ABSTRACT: Build a distribution with a bootstrapped version of itself.

use Dist::Zilla::App -command;



























































sub abstract { 'Build a distribution with a boostrapped version of itself' }

sub opt_spec { }

sub execute {
  my ( $self, $opt, $arg ) = @_;

  warn "Executing <<dzil @{$arg}>> under bootstrapped edition";

  my ( $target, $latest ) = $self->zilla->ensure_built_in_tmpdir;
  my $root = $self->zilla->root;

  require Data::Dump;
  require Path::Tiny;

  Data::Dump::pp({
    root => Path::Tiny::path($root)->absolute,
    target => $target,
    opt => $opt,
    arg => $arg,
  });
}

1;

__END__

=pod

=encoding UTF-8

=head1 NAME

Dist::Zilla::App::Command::self - Build a distribution with a bootstrapped version of itself.

=head1 VERSION

version 0.001000

=head1 SYNOPSIS

This is a different approach to using C<[Bootstrap::lib]> that absolves a distribution from needing to forcibly embed bootstrapping logic in C<dist.ini>

  dzil self build

This is largely similar to using C<[Bootstrap::lib]> and doing

  dzil build && dzil build

And similar again to:

  dzil run bash -c "cd ../; dzil -I$BUILDDIR/lib dzil build" 

Or whatever the magic is that @ETHER uses.

This also means that:

  dzil self release

Is something you can do.

=head1 CAVEATS

The nature of this implies that your distribution will probably need an older generation of itself for the intial bootstrap.

That is to say:

  dzil build

Must work, and use C<Generation.Previous> to build C<Generation.Build>

  dzil self foo

Will call C<dzil build> for you, to build C<Generation.Build>, and then invoke

  dzil foo

To use C<Generation.Build> to build C<Generation.Next>

=over 4

=item C<1. Generation.Previous>

A previously installed incarnation of your dist.

=item C<2. Generation.Build>

The iteration of building the distribution itself from source using C<Generation.Previous>

=item C<3. Generation.Next>

The iteration of building the distribution itself from source using C<Generation.Build>

=back

=head1 AUTHOR

Kent Fredric <kentfredric@gmail.com>

=head1 COPYRIGHT AND LICENSE

This software is copyright (c) 2014 by Kent Fredric <kentfredric@gmail.com>.

This is free software; you can redistribute it and/or modify it under
the same terms as the Perl 5 programming language system itself.

=cut
