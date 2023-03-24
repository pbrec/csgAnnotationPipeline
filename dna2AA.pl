#!/usr/bin/perl -w
use strict;

die "I need an input fasta. It will be translated starting with the first codon (Frame 1)\n", unless @ARGV==1;

open F,$ARGV[0] || die "cannot open $ARGV[0]: $!\n";

my$name="";
my$seq='';
while (my$line=<F>){

	$line=~s/\s+//g;
	if($line=~/^>/){

		&translatE($seq,$name), if($seq);
		$seq='';
		$name=$line;
	}
	else{
		$seq.=$line;
	}
}

&translatE($seq,$name), if($seq);

sub translatE{

        my($dna,$name)=@_;
        my@split=split /_/,$name;
        my$tr=$split[1];
        #my$add=$split[2]=~/\d+/?$split[2]:"";
        my%codons=("TTT" => "F","TCT" => "S","TAT" => "Y","TGT" => "C","TTC" => "F","TCC" => "S","TAC" => "Y","TGC" => "C","TTA" => "L","TCA" => "S","TAA" => "X", "TGA" => "X", "TTG" => "L","TCG" => "S","TAG" => "X", "TGG" => "W","CTT" => "L","CCT" => "P","CAT" => "H","CGT" => "R","CTC" => "L","CCC" => "P","CAC" => "H","CGC" => "R","CTA" => "L","CCA" => "P","CAA" => "Q","CGA" => "R","CTG" => "L","CCG" => "P","CAG" => "Q","CGG" => "R","ATT" => "I","ACT" => "T","AAT" => "N","AGT" => "S","ATC" => "I","ACC" => "T","AAC" => "N","AGC" => "S","ATA" => "I","ACA" => "T","AAA" => "K","AGA" => "R","ATG" => "M","ACG" => "T","AAG" => "K","AGG" => "R","GTT" => "V","GCT" => "A","GAT" => "D","GGT" => "G","GTC" => "V","GCC" => "A","GAC" => "D","GGC" => "G","GTA" => "V","GCA" => "A","GAA" => "E","GGA" => "G","GTG" => "V","GCG" => "A","GAG" => "E","GGG" => "G");

        #print "NT:\n$dna\n";
        my@triple=split//,$dna;
        my$as;
    
                while(my@tpl=splice @triple,0,3){
                my$tpl=join("",@tpl);
                $tpl=uc($tpl);
                if ($tpl=~m/N/){
                        $as.="X";
                }   
                else{   
                        unless (exists $codons{$tpl}){
                                print STDERR "Unknown template for $name: $tpl -> I'll add an X\n";
                                $as.="X";
                        }   
                        else{
                                $as.=$codons{$tpl};
                        }   
                }   
                #print"\rtranstlate $codons{$tpl}";
        }   
    
        print "$name\n$as\n";
}


