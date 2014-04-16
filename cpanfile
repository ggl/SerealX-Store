requires 'perl', '5.008001';
requires 'strict';
requires 'warnings';
requires 'Sereal', '2.0';

on configure => sub {
	requires 'Module::Build';
};

on build => sub {
	requires 'Test::More', '0.98';
};
