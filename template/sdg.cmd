#!/bin/bash
#SBATCH -o sdg_job.%j.%N.out
#SBATCH -D ./ 
#SBATCH -J LCZ4SDG 
#SBATCH --get-user-env
#SBATCH --export=NONE
#SBATCH --nodes=1-1
#SBATCH --cpus-per-task=64
#SBATCH --clusters mpp3
##SBATCH --partition=mpp3_batch
#SBATCH --export=NONE
#SBATCH --mail-type=all
#SBATCH --mail-user=y.wang@tum.de
#SBATCH --time=08:00:00

source /etc/profile.d/modules.sh
export OMP_NUM_THREADS=64
module load matlab

matlab -nodesktop -nosplash -nodisplay -r "cd('SDG_ROOT_DUMMY/mat_script'); enMIMA_Workflow_One_City('CITY_DIR_DUMMY', 'SDG_ROOT_DUMMY/mat_script'); exit"
#        !! Angabe des MATLAB-Skript in der -r Option ohne die Endung .m !!!
