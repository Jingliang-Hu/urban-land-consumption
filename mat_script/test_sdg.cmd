#!/bin/bash
#SBATCH -o sdg_job_test_low_mem.%j.%N.out
#SBATCH -D ./ 
#SBATCH -J LCZ4SDG 
#SBATCH --get-user-env
#SBATCH --export=NONE
#SBATCH --nodes=1-1
#SBATCH --mem=90000mb
#SBATCH --cpus-per-task=64
#SBATCH --clusters=mpp3
#SBATCH --export=NONE
#SBATCH --mail-type=all
#SBATCH --mail-user=jingliang.hu@dlr.de
#SBATCH --time=1:00:00

source /etc/profile.d/modules.sh
export OMP_NUM_THREADS=64
module load matlab

matlab -nodesktop -nosplash -nodisplay -r test_script


#        !! Angabe des MATLAB-Skript in der -r Option ohne die Endung .m !!!
