#!/bin/bash
#$ -cwd
#$ -o logs/A01b_rcd_between_donors.$JOB_ID.$TASK_ID
#$ -j y
#$ -N A01b_rcd_between_donors
#$ -l h_data=8G,h_rt=8:00:00
#$ -pe shared 8
#$ -t 1-9:1

echo "Job $JOB_ID.$SGE_TASK_ID started on:   " `hostname -s`
echo "Job $JOB_ID.$SGE_TASK_ID started on:   " `date `
echo " "

source ~/.bashrc

conda activate allcools

PROJDIR=/u/project/cluo/terencew/igvf/2023_YR2/snmCT/pseudobulk_allc/
cd $PROJDIR

### need to run it per-donor
# ID=1
ID=$SGE_TASK_ID
CLUSTERS=$PROJDIR/txt/rna_clusters.txt
CLUSTER=$(head -${ID} $CLUSTERS | tail -1)

CLUSTER_BY_DONOR=$PROJDIR/txt/allc_table/tmp/${CLUSTER}_rna_donor.txt
ALL_CLUSTS=$PROJDIR/txt/allc_table/rna_cluster_donor.txt

grep $CLUSTER $ALL_CLUSTS > $CLUSTER_BY_DONOR

CLUSTER_BY_DONOR=$PROJDIR/txt/allc_table/tmp/${CLUSTER}_rna_donor.txt

ALLC_INDIR=$PROJDIR/allc/rna_cluster_donor/
ALLC_PATHS=$PROJDIR/txt/allc_table/tmp/${CLUSTER}_rna_donor_allc_paths.txt
for CLUST in $(cat $CLUSTER_BY_DONOR);
do
    echo $ALLC_INDIR/${CLUST}.CGN-Merge.allc.tsv.gz
done > $ALLC_PATHS

mapfile -t TMP_CLUSTS < $CLUSTER_BY_DONOR
mapfile -t TMP_ALLC < $ALLC_PATHS

CLUST_LIST=$(echo "${TMP_CLUSTS[@]}")
ALLC_LIST=$(echo "${TMP_ALLC[@]}")

OUT=$PROJDIR/dmrs/methylpy/rna_cluster_donor/${CLUSTER}/${CLUSTER}

echo $CLUST_LIST $ALLC_LIST

time methylpy DMRfind \
  --allc-files $ALLC_LIST \
  --samples $CLUST_LIST \
  --mc-type 'CGN' \
  --num-procs 40 \
  --min-num-dms 1 \
  --output-prefix $OUT

echo "Job $JOB_ID.$SGE_TASK_ID started on:   " `hostname -s`
echo "Job $JOB_ID.$SGE_TASK_ID started on:   " `date `
echo " "
