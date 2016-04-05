#!/usr/bin/env perl

#
# to delete old backup use:
# ls -1 /var/backups/backup_*.tgz | perl filter_new.pl | xargs rm -f
#
# sudo apt-get install libdatetime-perl
#

use strict;
use DateTime;

my $date = DateTime->today();
my @seperators = ('', '-','_');
my $days = 7;

my @excludes = ();
for (my $i=0; $i < $days; $i++) {
	foreach my $seperator (@seperators) {
		push(@excludes, $date->ymd($seperator));
	}
	$date->subtract( days => 1 );
}

sub match {
	my $name = shift;
	return scalar(map { $name =~ /$_/ } @excludes) == 0;
}

while (<>) {
	if (match($_)) {
		print $_;
	}
}