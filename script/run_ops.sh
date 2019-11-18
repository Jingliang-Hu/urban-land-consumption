#!/bin/bash
# File              : run_sdg.sh
# Author            : Yuanyuan Wang <y.wang@tum.de>
# Date              : 06.05.2019 12:13:52
# Last Modified Date: 06.05.2019 12:13:52
# Last Modified By  : Yuanyuan Wang <y.wang@tum.de>

# use this script to submit jobs to cluster
# it loops over all the cities, and submit 1 job for each city

# get the first argument, i.e. the path of the order file
ORDER_FILE=$1


# give path of the Sentinel-1, Sentinel-2 and the GT data
DATA_DIR=`cat $ORDER_FILE|awk '/^data_directory/ {print $2}'| tr -d \"`
LINUX_CLUSTER=`cat $ORDER_FILE|awk '/^linux_cluster/ {print $2}'| tr -d \"`

#LABEL_DIR=`cat $ORDER_FILE|awk '/^label_directroy/ {print $2}'| tr -d \"`
echo "INFO:     Data directory " $DATA_DIR
echo "INFo:	Cluster " $LINUX_CLUSTER


# switch between different clusters
case $LINUX_CLUSTER in

	mpp3)

		# loop over all
		for CITY_DIR in $(ls -d $DATA_DIR/*/); do #list only the directories on DATA_DIR

        		# cd to the city dir
		        cd $CITY_DIR

        		# copy sbatch file to each processing dir
	        	cp -f $SDG_ROOT/template/ops.cmd .

	        	# replace strings in sdg.cmd
		        sed -i "s|CITY_DIR_DUMMY|${CITY_DIR}|g" ops.cmd
        		sed -i "s|SDG_ROOT_DUMMY|${SDG_ROOT}|g" ops.cmd

		        # submit job
	        	sbatch ops.cmd
		done

	;;


	inter)
		# submit one job, loop inside sdg_serial.cmd
		cp -f $SDG_ROOT/template/sdg_serial.cmd .
		
		sed -i "s|SDG_ROOT_DUMMY|${SDG_ROOT}|g" sdg_serial.cmd	
		sbatch sdg_serial.cmd

	;;
	
	
esac




