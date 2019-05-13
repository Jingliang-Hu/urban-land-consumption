#!/bin/bash
#SBATCH -o sdg_job.%j.%N.out
#SBATCH -D ./ 
#SBATCH -J LCZ4SDG 
#SBATCH --get-user-env
#SBATCH --export=NONE
#SBATCH --nodes=1-1
#SBATCH --mem=240000mb
#SBATCH --cpus-per-task=64
#SBATCH --clusters=inter
#SBATCH --partition=teramem_inter
#SBATCH --export=NONE
#SBATCH --mail-type=all
#SBATCH --mail-user=jingliang.hu@dlr.de
#SBATCH --time=15:00:00

source /etc/profile.d/modules.sh
export OMP_NUM_THREADS=64
module load matlab

matlab -nodesktop -nosplash -nodisplay -r "cd('SDG_ROOT_DUMMY/mat_script'); try enMIMA_Workflow_One_City('CITY_DIR_DUMMY', 'SDG_ROOT_DUMMY/mat_script'); catch; end; exit"
#        !! Angabe des MATLAB-Skript in der -r Option ohne die Endung .m !!!
