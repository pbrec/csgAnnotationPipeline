#!/usr/bin/perl -w
use strict;

my$exOUT=$ARGV[0];

open IN,$exOUT || die "cannot open $exOUT: $!\n";

my$p=0;
while (my$line=<IN>){

	if($line=~/START OF GFF DUMP/){
		$p=1;		
	}
	elsif($line=~/END OF GFF DUMP/){
		$p=0;
	}
	elsif($p){
		print $line, unless($line=~/^#/);
	}
}
