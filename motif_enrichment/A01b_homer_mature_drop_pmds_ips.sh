#!/bin/bash
#$ -cwd
#$ -o logs/A06b_homer_mature_ips_drop_pmds.$JOB_ID.$TASK_ID
#$ -j y
#$ -N A06b_homer_mature_ips_drop_pmds
#$ -l h_data=4G,h_rt=4:00:00
#$ -pe shared 2
#$ -t 1-22:1

echo "Job $JOB_ID.$SGE_TASK_ID started on:   " `hostname -s`
echo "Job $JOB_ID.$SGE_TASK_ID started on:   " `date `
echo " "

source ~/.bashrc

PROJDIR=/u/home/t/terencew/project-cluo/igvf/2023_YR2/snmCT/pseudobulk_allc
cd $PROJDIR

HOMER_PATH=/u/home/t/terencew/project-cluo/programs/homer/bin/
export PATH=$PATH:$HOMER_PATH
MOTIFS=$HOMER_PATH/findMotifsGenome.pl

# ID=1
ID=${SGE_TASK_ID}
# ANNOTS=$PROJDIR/txt/donors.txt
ANNOTS=$PROJDIR/txt/tmp/tmp_great.txt
ANNOT=$(head -${ID} $ANNOTS | tail -1)

INDIR=$PROJDIR/csv/dmrs/mature_ips_drop_pmds/by_group

###
DMRS=$INDIR/${ANNOT}_hypo_dms1.csv
OUT=$PROJDIR/motifs/mature_ips_drop_pmds/${ANNOT}_hypo
time $MOTIFS $DMRS hg38 $OUT -size given -p 8

###
DMRS=$INDIR/${ANNOT}_hyper_dms1.csv
OUT=$PROJDIR/motifs/mature_ips_drop_pmds/${ANNOT}_hyper
time $MOTIFS $DMRS hg38 $OUT -size given -p 8

echo "Job $JOB_ID.$SGE_TASK_ID started on:   " `hostname -s`
echo "Job $JOB_ID.$SGE_TASK_ID started on:   " `date `
echo " "
