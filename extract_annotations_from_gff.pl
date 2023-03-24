#!/usr/bin/perl -w
use strict;

##NW_003789703.1  exonerate:protein2genome:local  gene    688458  689989  1757    -       .       gene_id 2 ; sequence AmOr17 ; gene_orientation +
#NW_003789703.1  exonerate:protein2genome:local  cds     689202  689989  .       -       .       
#NW_003789703.1  exonerate:protein2genome:local  exon    689202  689989  .       -       .       insertions 0 ; deletions 0
#NW_003789703.1  exonerate:protein2genome:local  splice5 689200  689201  .       -       .       intron_id 1 ; splice_site "GT"
#NW_003789703.1  exonerate:protein2genome:local  intron  689076  689201  .       -       .       intron_id 1
#NW_003789703.1  exonerate:protein2genome:local  splice3 689076  689077  .       -       .       intron_id 0 ; splice_site "AG"
#NW_003789703.1  exonerate:protein2genome:local  cds     688976  689075  .       -       .       
#NW_003789703.1  exonerate:protein2genome:local  exon    688976  689075  .       -       .       insertions 0 ; deletions 0
#NW_003789703.1  exonerate:protein2genome:local  splice5 688974  688975  .       -       .       intron_id 2 ; splice_site "GT"
#NW_003789703.1  exonerate:protein2genome:local  intron  688920  688975  .       -       .       intron_id 2
#NW_003789703.1  exonerate:protein2genome:local  splice3 688920  688921  .       -       .       intron_id 1 ; splice_site "AG"
#NW_003789703.1  exonerate:protein2genome:local  cds     688809  688919  .       -       .       
#NW_003789703.1  exonerate:protein2genome:local  exon    688809  688919  .       -       .       insertions 0 ; deletions 0
#NW_003789703.1  exonerate:protein2genome:local  splice5 688807  688808  .       -       .       intron_id 3 ; splice_site "GT"
#NW_003789703.1  exonerate:protein2genome:local  intron  688737  688808  .       -       .       intron_id 3
#NW_003789703.1  exonerate:protein2genome:local  splice3 688737  688738  .       -       .       intron_id 2 ; splice_site "AG"
#NW_003789703.1  exonerate:protein2genome:local  cds     688581  688736  .       -       .       
#NW_003789703.1  exonerate:protein2genome:local  exon    688581  688736  .       -       .       insertions 0 ; deletions 0
#NW_003789703.1  exonerate:protein2genome:local  splice5 688579  688580  .       -       .       intron_id 4 ; splice_site "GT"
#NW_003789703.1  exonerate:protein2genome:local  intron  688506  688580  .       -       .       intron_id 4
#NW_003789703.1  exonerate:protein2genome:local  splice3 688506  688507  .       -       .       intron_id 3 ; splice_site "AG"
#NW_003789703.1  exonerate:protein2genome:local  cds     688458  688505  .       -       .       
#NW_003789703.1  exonerate:protein2genome:local  exon    688458  688505  .       -       .       insertions 0 ; deletions 0
#NW_003789703.1  exonerate:protein2genome:local  similarity      688458  689989  1757    -       .       alignment_id 2 ; Query AmOr17 ; Align 689990 1 786 ; Align 689

#NW_003789703.1_684696_11_1
die "need list and gff file to work\n", unless @ARGV==2;
my($l,$g)=@ARGV;

open I,$l || die "cannot open listfile: $!\n";

my%list;
while(my$line=<I>){
	$line=~s/\s+//g;
	my@s=split/_/,$line;
	$list{$s[2]}=$s[4];
}
close I;

open G, $g || die "cannot open gff file: $!\n";
my$p=0;
while(my$line=<G>){

	if($line=~m/gene/){
		$p=0;
		my@s=split/\s+/,$line;
		if(exists($list{$s[4]})){
			$p=1, if($list{$s[4]} == $s[9]);
		}
	}
	if($p){
		print $line;
	}

}


