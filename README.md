# ---- Simple run with matlab ----
Checkout the README file in directory mat_script


# ---- Multi-processing on LRZ linux cluster ------
## Step 1, setup enviroment, i.e. change the path of the processor in env_example.sh
source env_example.sh


## Step 2, copy order.pp to some where, and change the processing parameters
## In this work, you need to change the data directory which contains all the cities
## you can also change the linux_cluster to either mpp3 or inter.
cp template/order.pp YOUR_DIRECTORY


## Step3, run the processor. It will submit all the job 
run_sdg.sh order.pp


