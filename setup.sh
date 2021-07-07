#!/bin/bash

# To run this script, type: bash setup.sh subjectname

## Script that sets up the necessary directory structure for fMRI processing on CMIG server

## Pass the subject's ID when running this script (e.g.bash setup.sh sub-pilot01)

if [ $# -eq 0 ]
  then
    echo "No arguments supplied..."
    echo "Please supply subject ID."
    echo "Example: bash setup.sh sub-pilot01"
    exit
else
	echo "Subject ID is" $1
	echo "Runnning script..."
	echo "Setting up file structure..."
fi

#: <<'END'

sub=$1
workdir=/home/mmilmcd2/fmri_processing/afni
subjdir=/home/mmilmcd2/fmri_processing/afni/$sub
fmriprepdir=/home/mmilmcd2/fmri_processing/fmriprep/derivatives/fmriprep/$sub

# create all necessary dirs and copy data over from master_code directory

mkdir $subjdir; cd $subjdir

mkdir -p code afni_out regressor_files/FN regressor_files/VPA stimuli/FN stimuli/VPA native_func native_afni_out

cd $workdir/master_code; cp * $subjdir/code

echo $sub >> $workdir/subjlist.txt

### COPY DATA FROM FMRIPREP INTO subject's dir.

echo "Copying files..."

cd $fmriprepdir
cp -r * $subjdir



echo "Done!"
echo "Take a look and make sure all the directories are present"
echo "And the fmriprep data successfully copied over."


echo "The regressor_files directory is for the motion files from fMRIPrep. The stimuli directory is for the timing files. The afni_out and native_afni_out dirs are for the output from afni 3Ddeconvolve. native_func is for functional data output into native space from fmriprep." > $subjdir/README.txt

cd $subjdir; ls


