# Urban land classification using Sentinel-1 and Sentinel-2 data with a manifold fusion strategy (MIMA)
![An example of Mumbai](https://github.com/Jingliang-Hu/urban-land-consumption/blob/master/an_example_of_mumbai.jpg)
Caption: An example of Mumbai

This repository contains the code of the classification system applied in the following paper
> Jingliang Hu, Yuanyuan Wang, Hannes Taubenböck, Xiao Xiang Zhu (2021). Land Consumption in Cities: A Comparative Study Across the Globe. Cities.

The paper can be freely accessed [here](https://www.sciencedirect.com/science/article/pii/S0264275121000615).

For citation:
```bibtex
@article{hu2021land,
  title={Land consumption in cities: A comparative study across the globe},
  author={Hu, Jingliang and Wang, Yuanyuan and Taubenb{\"o}ck, Hannes and Zhu, Xiao Xiang},
  journal={Cities},
  volume={113},
  pages={103163},
  year={2021},
  publisher={Elsevier}
}
```

## Simple run with matlab
Step 1: 
> Download the exemplary data for Nairobi using the link blow. Place the data directory in this folder "mat_script".
> 
> ftp://ftp.lrz.de/transfer/urban_land_consumption_nairobi/

Step 2: 
> Brower to folder "mat_script", run the script "example_script.m" with the example of city Nairobi


## Multi-processing on LRZ linux cluster
### Step 1, setup enviroment, i.e. change the path of the processor in env_example.sh
source env_example.sh

### Step 2, copy order.pp to some where, and change the processing parameters
### In this work, you need to change the data directory which contains all the cities
### you can also change the linux_cluster to either mpp3 or inter.
cp template/order.pp YOUR_DIRECTORY

### Step3, run the processor. It will submit all the job 
run_sdg.sh order.pp



