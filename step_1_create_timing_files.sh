#!/bin/bash

# ====================== STEP 1 AFTER FMRIPREP ===============================

## This script will take the timing files output from E-prime and put them into txt form, then finally AFNI or .1D format.

workdir=~/fmri_processing/afni

## SUBJLIST SHOULD HAVE A LIST OF ALL SUBJECTS IN FIRST COLUMN

## YOU WILL NEED THE TIMING FILES FROM DROPBOX, SHOULD BE PLACED IN THE FUNC DIR

cd ${workdir}

#Check whether the file subjList.txt exists; if not, create it
if [ ! -f subjlist.txt ]; then
	ls | grep ^sub- > subjlist.txt
fi

sub=$( tail -n 1 subjlist.txt )

#Loop over all subjects and format timing files into txt format for FN runs 1 and 2
for subj in $sub; do
	cd ${workdir}/$subj/func
	cat ${subj}_task-FN_run-1_events.tsv | awk '{if ($3=="PSSNovel") {print $1, $2, 1}}' > PSSnovel_run1.txt
	cat ${subj}_task-FN_run-1_events.tsv | awk '{if ($3=="Novel") {print $1, $2, 1}}' > novel_FN_run1.txt
	cat ${subj}_task-FN_run-1_events.tsv | awk '{if ($3=="Repeated") {print $1, $2, 1}}' > repeated_run1.txt
	cat ${subj}_task-FN_run-1_events.tsv | awk '{if ($3=="Arrow") {print $1, $2, 1}}' > arrow_run1.txt
	cat ${subj}_task-FN_run-1_events.tsv | awk '{if ($3=="ISI") {print $1, $2, 1}}' > isi_FN_run1.txt

	cat ${subj}_task-FN_run-2_events.tsv | awk '{if ($3=="PSSNovel") {print $1, $2, 1}}' > PSSnovel_run2.txt
	cat ${subj}_task-FN_run-2_events.tsv | awk '{if ($3=="Novel") {print $1, $2, 1}}' > novel_FN_run2.txt
	cat ${subj}_task-FN_run-2_events.tsv | awk '{if ($3=="Repeated") {print $1, $2, 1}}' > repeated_run2.txt
	cat ${subj}_task-FN_run-2_events.tsv | awk '{if ($3=="Arrow") {print $1, $2, 1}}' > arrow_run2.txt
	cat ${subj}_task-FN_run-2_events.tsv | awk '{if ($3=="ISI") {print $1, $2, 1}}' > isi_FN_run2.txt

#================================= This will need to be change to VPA in the near Future =======================

# Loop over all subjects and format timing files into FSL format for MST runs 1 and 2

: <<'END'


	cat ${subj}_task-MST_run-1_events.tsv | awk '{if ($3=="Novel") {print $1, $2, 1}}' > MST_novel_run1.txt
	cat ${subj}_task-MST_run-1_events.tsv | awk '{if ($3=="Base") {print $1, $2, 1}}' > MST_base_run1.txt
	cat ${subj}_task-MST_run-1_events.tsv | awk '{if ($3=="Rep") {print $1, $2, 1}}' > MST_rep_run1.txt
	cat ${subj}_task-MST_run-1_events.tsv | awk '{if ($3=="Lure") {print $1, $2, 1}}' > MST_lure_run1.txt
	cat ${subj}_task-MST_run-1_events.tsv | awk '{if ($3=="ISI") {print $1, $2, 1}}' > isi_MST_run1.txt


	cat ${subj}_task-MST_run-2_events.tsv | awk '{if ($3=="Novel") {print $1, $2, 1}}' > MST_novel_run2.txt
	cat ${subj}_task-MST_run-2_events.tsv | awk '{if ($3=="Base") {print $1, $2, 1}}' > MST_base_run2.txt
	cat ${subj}_task-MST_run-2_events.tsv | awk '{if ($3=="Rep") {print $1, $2, 1}}' > MST_rep_run2.txt
	cat ${subj}_task-MST_run-2_events.tsv | awk '{if ($3=="Lure") {print $1, $2, 1}}' > MST_lure_run2.txt
	cat ${subj}_task-MST_run-2_events.tsv | awk '{if ($3=="ISI") {print $1, $2, 1}}' > isi_MST_run2.txt

END

#Convert to AFNI format for FN 
echo "Converting to .1D format..."
sleep 2	
	timing_tool.py -fsl_timing_files PSSnovel*.txt -write_timing FN_PSSnovel.1D
	timing_tool.py -fsl_timing_files novel_FN*.txt -write_timing FN_novel.1D
	timing_tool.py -fsl_timing_files repeated*.txt -write_timing FN_repeated.1D
	timing_tool.py -fsl_timing_files isi_FN*.txt -write_timing FN_isi_FN.1D
	timing_tool.py -fsl_timing_files arrow*.txt -write_timing FN_arrow.1D
	
#Convert to AFNI format for MST

#	timing_tool.py -fsl_timing_files MST_novel_run*.txt -write_timing MST_novel.1D
#	timing_tool.py -fsl_timing_files MST_base_run*.txt -write_timing MST_base.1D
#	timing_tool.py -fsl_timing_files MST_rep_run*.txt -write_timing MST_rep.1D
#	timing_tool.py -fsl_timing_files MST_lure_run*.txt -write_timing MST_lure.1D
#	timing_tool.py -fsl_timing_files isi_MST_run*.txt -write_timing isi_MST.1D

#cp MST_*.1D ~/research_bin/r01/BIDS/derivatives/fmriprep/sub-alena/stimuli/MST
cp FN_*.1D ../stimuli/FN

#cd ~/research_bin/BIDS/derivatives/fmriprep/sub-alena/stimuli/MST

ls | grep .1D

done

echo "Check the output and see if it's what you were expecting."
echo "If there weren't any errors and the output looks okay, move on to the next step:"
echo "smooth and scale"
echo "You should see a .1D file for each condition."

sleep 15

echo "Running step 2..."

sleep 5

bash $workdir/$sub/code/step_2_smooth_and_scale.sh
