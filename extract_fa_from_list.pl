#! /usr/bin/perl -w
use strict;

my$min=0;
#input 	1. List with headers
#	2. fasta file to extract from

die "need <list> and <.fa> to work\n", unless(@ARGV==2);

open IN, $ARGV[0] || die "cannot open $ARGV[0]: $!\n";

my%list;
while(<IN>){
	my@s=split/\s+/;

	if($s[0]=~m/AmelOr\d+/i){
		$s[0]=~s/AmelOr/AmOr/i;
		$s[0]=~s/[a-zA-Z]+$//i;
	}
	$list{$s[0]}=0;
} 
close IN;

open F, $ARGV[1] || die "cannot open $ARGV[1]: $!\n";


my$on=0;
while (my$line=<F>){

	#if($line=~m/^>([\d_]+)\s+/){
	#if($line=~m/^>([\d\D]+)\s+/){
	if($line=~m/^>/){
		$line=~s/>//;
		$line=~s/\s+[\d\D]+//;
		if($line=~/AmOR/i){
			$line=~s/[a-zA-Z]+$//i;
		}
		chomp($line);
		$on=exists($list{$line})?">$line\n":0;
		if($on){
			print $on;
			delete($list{$line});
		}
	}
	else{
		#$on=0,if(length($line)<=$min);
		print "$line", if $on;

	}

}

foreach my$key(keys%list){

	print STDERR "$key couldn't be found in fasta input\n";

}
