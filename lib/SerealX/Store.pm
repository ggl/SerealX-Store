package SerealX::Store;
# ABSTRACT: Sereal based persistence for Perl data structures
our $VERSION = '0.001';

use 5.008001;
use strict;
use warnings;

use Sereal::Encoder;
use Sereal::Decoder;

# Constructor
sub new {
	my $class = shift;
	my $self = {};
	return bless $self, $class;
}

sub store {
	my ($self, $data, $path) = @_;

	die "No handle or path specified" unless $path;
	if (ref $self->{encoder} ne 'Sereal::Encoder') {
		$self->{encoder} = Sereal::Encoder->new();
	}
	open(my $fh, ">", $path) or die "Cannot open file $path: $!";
	binmode $fh;
	print $fh $self->{encoder}->encode($data)
		or die "Cannot write fo $path: $!";
	close $fh or die "Cannot close $path: $!";

	return 1;
}

sub retrieve {
	my ($self, $path) = @_;

	die "No handle or path specified" unless $path;
	if (ref $self->{decoder} ne 'Sereal::Decoder') {
		$self->{decoder} = Sereal::Decoder->new();
	}
	open(my $fh, "<", $path) or die "Cannot open file $path: $!";
	binmode $fh;
	my $data;
	if (my $size = -s $fh) {
		my ($pos, $read) = 0;
		while ($pos < $size) {
			defined($read = read($fh, $data, $size - $pos, $pos))
				or die "Cannot read file $path: $!";
			$pos += $read;
		}
	}
	else {
		$data = <$fh>;
	}
	close $fh or die "Cannot close $path: $!";
	$self->{decoder}->decode($data, my $decoded);
	
	return $decoded;
}
