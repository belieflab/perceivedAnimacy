Created by Santiago Castiello (17/05/2022). Special thanks to Josh Kenney.



# # # # index # # # #
	Main Scripts
	Other scripts
	data.frames 
	terminal commands



# # # # Main Scripts # # # #
calculate_discs_distances.R
	It is used to calculate distances and angles from the 600 stimuli (displays) 
	created by Ben van Buren for a perceived animacy task.

visualize_parametric_spaceR
	It is used to visualize and simulate the parametric space from the Perceived 
	Animacy model that I created. The simulations are based on the 600 displays created 
	by Ben van Buren.

simulate_good_parameters.R
	In this script we used the parametric space ran with function f_SDTparamExplor in 
	the script: visualize_parametric_space.R. Then we simulate N "participants" with a 
	random decision rule "eta" parameter.

parameters_recovery.R
	Master parameter recovery. Simulate wide range of the parametric space and obtain
	the whole posterior density, parameter estimation is the weighted mean of the marginals.
	Fitting function is f_fitDetMod within functions.R

functions.R
	Functions used in the previous scripts, more descriptions inside this script.



# # # # Other Scripts # # # #
../modelParametersRecoveryBatch/create_multiple_files.R
	Used to change the name of duplicated files in batch_scripts and batch_rc. Given that
	I don't know how to run code in paralell, then Josh suggested to run one Batch per
	artificial participant. Therefore we duplicated R scripts and batchs.



# # # # data.frames # # # #
discsPositions.csv
	All 600 trials positions for all the discs. Created by Ben van Buren.
	Print by calculate_discs_distances.R

discsAngles.csv
	All 600 trials and all discs angles.
	Print by calculate_discs_distances.R

discsDistances.csv
	All 600 trials and all discs Euclidian distances.
	Print by calculate_discs_distances.R

sdtParameters.csv
	All the parametric space made with f_SDTparamExplor within functions.R 
	Print by visualize_parametric_space.R

simPars.csv
	55 "good" parameters (based on arbitrary "good" performance). 
	Print by simulate_good_parameters.R

simTrials.csv [removed and substituted for sim_data, individual files. More similar to actual participants]
	Trial by trial for the 55 "good" artificial participants.
	Print by simulate_good_parameters.R

simRandDist.csv
	discs distances for 100 chase + 100 mirror randomized trials.
	Print by simulate_good_parameters.R



# # # # terminal commands # # # #
connect to the farm
	ssh sc3228@farnam.hpc.yale.edu

to exist the farnam
	<code> exit </code>

will run the script specified in .sh
	<code> sbatch batch.sh </code>

create an interactive session through the comand line
	<code> srun --pty -p interactive --mem=1gb bash </code>

status of a particular job
	<code> squeue -j 26341352 </code> # the number is the job

to see what R did
	<code> cat slurm-26341352.out </code> # cat [print something]



# # # # Git Token # # # # 
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



# # # # [in terminal: https://ood-farnam.hpc.yale.edu/pun/sys/shell/ssh/farnam.hpc.yale.internal] # # # # 
# "manual" open on demand. Activate the R version (similar to onDemand arnam)
module load R/4.1.0-foss-2020b 

# to execute code: (when the R script have already commandArgs())
Rscript [filename.R] 