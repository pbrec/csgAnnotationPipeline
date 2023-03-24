#!/usr/bin/perl -w

use strict;

#this script takes a fasta file and saves it to memory as a hash.
#then it takes a gff file and extracts all ORFs as indicated by the cds column. ORs on the - strand will be reverse complemented
#the description in the fasta file and the gff file must match.

die "The script needs 2 input files: <.fa> <.gff>\n", unless(@ARGV==2);

my($fa,$gff)=@ARGV;

print STDERR "reading fasta file\n";
open F,$fa || die "cannot open fasta file $fa: $!\n";

my%fa;

my$on=0;
while (my$line=<F>){
	next, if($line=~/^\s+$/);

	if($line=~/^>([\d\D]+)\s+/){
		$on=$1;
		$on=~s/\s+[\d\D]+$//;
		$fa{$on}=();
	}
	elsif($on){
		$line=~s/\s+$//;
		$fa{$on}.=$line;
	}

}
close F;
print STDERR "DONE\n";

print STDERR "reading gff-file\n";

open G, $gff || die "cannot open gff file $gff: $!\n";

my%gff;

my$ORF=();
my$geneid=0;
my$range="";
my$add="";
while (my$line=<G>){

	if($line=~/gene/){
		$geneid++;
		my@s=split/\s+/,$line;
		$add=$geneid;
		$add.="_$s[9]",if($s[9]);

		if($line=~/Name=([\w\W]+)\s+/ || $line=~/ID=([\w\W]*?);/){
			$add.=".$1";
		}
	}
	elsif($line=~/\s+cds\s+/i){

		push(@{$gff{$add}},$line);
	}


}	
close G;

print STDERR "DONE\n";

my($start,$end)=();
my$rev;

sub by_synteny {
	my@s=split /\s+/, ${$gff{$a}}[0];
	my@s2=split /\s+/, ${$gff{$b}}[0];
	$s[3] <=> $s2[3];
}

foreach my$gene (reverse sort by_synteny keys %gff){

	my@s=split /\s+/, ${$gff{$gene}}[0];

	#print "@s\n"; exit;
		$rev=0;
	if ($s[6] eq "-"){

		$rev=1;
		@{$gff{$gene}}=reverse @{$gff{$gene}};

	}

	my$ORF=();
	foreach my $ex (@{$gff{$gene}}){
		my@s2=split/\s+/, $ex;
		
		$start=$s2[3];
		$end=$s2[4];
		if($start && $end && $fa{$s[0]}){
			$ORF.=substr($fa{$s[0]},$start-1,($end-$start)+1);
		}
		else{
			print STDERR "err. in $ex\n";
			print STDERR "start: $start\n";
			print STDERR "end: $end\n";
			print STDERR "string: $fa{$s[0]}\n";}
	}
	$ORF=uc($ORF);
	if($rev){
		$ORF=reverse$ORF;
		$ORF=~tr/AGCT/TCGA/;
	}

	
	print ">$s[0]_$end\_$gene\n$ORF\n";

}
