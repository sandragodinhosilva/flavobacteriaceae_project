#!/usr/bin/perl -n
use strict;
use warnings;

chomp;
my(@values)=split(",",$_);
my(@runs,@project,@sample);

foreach $a (@values){
	if ($a =~ /^[EDS]RR\d+/){push @runs,$a;}
	elsif ($a =~ /^PRJ\w+/){push @project,$a;}
	elsif ($a =~ /^SAM\w+/){push @sample,$a;}
}

print "$project[0]\t"; print "$sample[0]\t"; print join (",",@runs); print "\n";
