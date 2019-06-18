#!/bin/bash
#SBATCH -o sdg_job_test_corr.%j.%N.out
#SBATCH -D ./ 
#SBATCH -J LCZ4SDG_testSDG
#SBATCH --get-user-env
#SBATCH --export=NONE
#SBATCH --nodes=1-1
#SBATCH --mem=90000mb
#SBATCH --cpus-per-task=64
#SBATCH --clusters=mpp3
#SBATCH --export=NONE
#SBATCH --mail-type=all
#SBATCH --mail-user=jingliang.hu@dlr.de
#SBATCH --time=10:00:00

source /etc/profile.d/modules.sh
export OMP_NUM_THREADS=64
module load matlab

matlab -nodesktop -nosplash -nodisplay -r test_script1


#        !! Angabe des MATLAB-Skript in der -r Option ohne die Endung .m !!!
