#!/bin/bash
#SBATCH -o sdg_job.%j.%N.out
#SBATCH -D ./ 
#SBATCH -J LCZ4SDG 
#SBATCH --get-user-env
#SBATCH --export=NONE
#SBATCH --nodes=1-1
#SBATCH --mem=4000000mb
##SBATCH --cpus-per-task=64
#SBATCH --clusters=inter
#SBATCH --partition=teramem_inter
#SBATCH --mail-type=all
#SBATCH --mail-user=y.wang@tum.de
#SBATCH --time=48:00:00

source /etc/profile.d/modules.sh
export OMP_NUM_THREADS=96
module load matlab


for CITY_DIR in $(ls -d DATA_DIR_DUMMY/*/); do

	## cd to the city dir
        cd $CITY_DIR
	if [ ! -f OK.finish ]; then
      		matlab -nodesktop -nosplash -nodisplay -r "cd('SDG_ROOT_DUMMY/mat_script'); try enMIMA_Workflow_One_City('$CITY_DIR', 'SDG_ROOT_DUMMY/mat_script'); catch; end; " &
        else
		echo "INFO: $CITY_DIR Already processed."
        fi
done

wait

#        !! Angabe des MATLAB-Skript in der -r Option ohne die Endung .m !!!
