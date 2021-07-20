#### Python Script that appends contents of one text file to another for FN task


######### Step 4 After FMRIPREP ###########

### Grab 2nd argument

import sys
import os
import time
import pandas as pd

arg_list = sys.argv

subject = arg_list[1]

# Run 1

tsv_file=f'{subject}_task-FN_run-1_desc-confounds_timeseries.tsv'
csv_table=pd.read_table(tsv_file, sep='\t')
csv_table.to_csv(f'{subject}-FN_run-1_timeseries.csv', index=False)


col_list = ["trans_x", "trans_y", "trans_z", "rot_x", "rot_y", "rot_z"]

df = pd.read_csv(f"{subject}-FN_run-1_timeseries.csv", usecols=col_list)

df.to_csv (r'FN_run_1.csv', index = False, header=True)

# Run 2

tsv_file=f'{subject}_task-FN_run-2_desc-confounds_timeseries.tsv'
csv_table=pd.read_table(tsv_file, sep='\t')
csv_table.to_csv(f'{subject}-FN_run-2_timeseries.csv', index=False)


col_list = ["trans_x", "trans_y", "trans_z", "rot_x", "rot_y", "rot_z"]

df = pd.read_csv(f"{subject}-FN_run-2_timeseries.csv", usecols=col_list)

df.to_csv (r'FN_run_2.csv', index = False, header=True)



print("Done!")
time.sleep(2)
print("Check for any errors.")
time.sleep(10)
print("Running step 5: csv_to_text.sh...") 
time.sleep(3)
os.chdir("/home/mmilmcd2/fmri_processing/afni")
os.chdir(f"{subject}/code")

os.system("bash step_5_csv_to_text.sh")
