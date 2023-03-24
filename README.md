# csgAnnotationPipeline

## general annotation pipeline 

This pipeline 

1. find scaffolds with hits using `tblastn` 
```
tblastn -query <query.mfa> -db <genome.db> -evalue 10E-6 -num_threads 3 -outfmt '6 qseqid sseqid length qstart qend sstart send evalue bitscore pident nident' > <tblastn_out.txt>
```

2. extract scaffolds with blast hits using `extract_fa_from_list.pl` script
`perl extract_fa_from_list.pl <genome_scaffolds.fa> > scaffolds_with_hits.fa`

3. run exonerate on those scaffolds to annotate genes while predicting exon-intron boundaries 
`exonerate --model protein2genome --showtargetgff --percent 60 <query.mfa> scaffolds_with_hits.fa > exonerate.out`
if little genes are annotated, re-run the command with `--percent` set to 25

4. extract gff dump from exonerate output to visualize annotations using `extract_gff_dump_from_exonerate_output.pl`
`perl extract_gff_dump_from_exonerate_output.pl exonerate.out >exonerate.gff` 
    
5. extract annotations from the gff file using `extract_ORFs_from_gff.pl` script
`perl ../../../scripts/extract_ORFs_from_gff.pl scaffolds_withORhits.fa exonerate.gff > round1DNA.fa` 

6. translate DNA sequences to AA using `dna2AA.pl` script
`perl ../../../scripts/dna2AA.pl round1DNA.fa >round1AA.fa` 

7. combine AA sequences of annotations with AA queries and/or genes of interest suitable to check annotations
`cat round1AA.fa <queries.mfa> <...> > annotations_queries_combined_R1.fa`

8. align all those AA sequences
`mafft --reorder --thread 4 --maxiterate 1000 --localpair annotations_queries_combined_R1.fa >annotations_queries_combined_R1-align.fa`

9. use alignments to visually examine annotations. cross reference with annotations in the genome


## create gene tree 
Combine finished annotations and genes of other species and align (step 7. and 8. above). Then use `raxml` to infer a gene tree 
`raxmlHPC-PTHREADS-SSE3 -T 16 -f a -m PROTGAMMAJTT -p 12345 -x 12345 -N 100 -s input-align.fa  -n <tree_name>.rapd`

This command will create a tree using the rapd algorithm and 100 bootstraps. For a final tree 1000 bootstraps are more reliable to draw conclusions, so `-
N` should be set to 1000
