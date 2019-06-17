#!/bin/bash
#SBATCH -o nyc_mima.%j.%N.out
#SBATCH -D ./
#SBATCH -J nyc_mima
#SBATCH --get-user-env
#SBATCH --clusters=inter
#SBATCH --partition=teramem_inter
#SBATCH --mem=160000mb
#SBATCH --cpus-per-task=1
#SBATCH --mail-type=all
#SBATCH --mail-user=jingliang.hu@dlr.de
#SBATCH --export=NONE
#SBATCH --time=03:00:00


matlab -nodesktop -nosplash -nodisplay -r mima_2t_pc_sc_exp



#        !! Angabe des MATLAB-Skript in der -r Option ohne die Endung .m !!!
