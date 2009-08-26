package Test::memcached;
use Any::Moose;
our $VERSION = '0.01';
use Cwd;
use File::Temp qw(tempdir);
use POSIX qw(SIGTERM WNOHANG);
use Test::TCP qw/empty_port wait_port/;
use File::Which qw/which/;

has auto_start => (
		   is => 'ro',
		   isa => 'Int',
		   default => 2,
);

has memcached => (
		  is => 'ro',
);

has executable => (
		   is => 'ro',
		   isa => 'Str',
		   default => sub {
		     which('memcached')
		   },
);

has pid => (
	    is => 'rw',
	    isa => 'Int|Undef',
);

has port => (
	     is => 'ro',
	     isa => 'Int',
	     default => sub { empty_port() },
	    );

sub BUILD {
  my $self = shift;
  if ($self->auto_start) {
    $self->start;
  }
}

sub DEMOLISH {
    my $self = shift;
    $self->stop
        if defined $self->pid;
}

sub start {
  my $self = shift;
  return
    if defined $self->pid;
  my $pid = fork;
  die "fork(2) failed:$!"
    unless defined $pid;
  if ($pid == 0) {
    my @cmd = (
	       $self->executable,
	       '-p',
	       $self->port);
    exec(@cmd);
    die "failed to launch memcached:$?";
  }
  wait_port($self->port);
  $self->pid($pid);
}

sub stop {
  my ($self, $sig) = @_;
  return
    unless defined $self->pid;
  $sig ||= SIGTERM;
  kill $sig, $self->pid;
  while (waitpid($self->pid, 0) <= 0) {
  }
  $self->pid(undef);
  # might remain for example when sending SIGKILL
}

no Any::Moose;
__PACKAGE__->meta->make_immutable;
__END__

=head1 NAME

Test::memcached -

=head1 SYNOPSIS

  use Cache::Memcached;
  use Test::memcached;
  use Test::More;
  
  my $memcached = Test::memcached->new(
  );
  
  plan tests => XXX;
  
  my $dbh = Cache::Memcached->new(
    servers => ['127.0.0.1:'.$memcached->port],
    ...
  );

=head1 DESCRIPTION

Test::memcached is

=head1 AUTHOR

Tokuhiro Matsuno E<lt>tokuhirom  slkjfd gmail.comE<gt>

=head1 SEE ALSO

=head1 LICENSE

This library is free software; you can redistribute it and/or modify
it under the same terms as Perl itself.

=cut
