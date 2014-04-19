#!perl

use strict;
use warnings;

use Test::More;
use SerealX::Store;

my $st = SerealX::Store->new();
isa_ok($st, 'SerealX::Store');
my $data = {
	a => 1,
	b => 'foo',
	c => [1, 'bar'],
	d => { a => 1, b => 'foo' },
	e => undef,
	#f => sub { 1 },
};
my $rand = join('', map(("a".."z","A".."Z","0".."9")[rand 62], 0..7));
my $path = '/tmp/test.'.$rand;
$st->store($data, $path);
my $decoded = $st->retrieve($path);
unlink($path);
is_deeply($decoded, $data);

done_testing();
