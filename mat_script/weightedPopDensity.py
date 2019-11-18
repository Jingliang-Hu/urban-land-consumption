import glob
import numpy as np
import matplotlib.pyplot as plt

from osgeo import gdal
from scipy import stats
from scipy.misc import imresize

##################################################################################
# extract lcz local cooccurance feature
path2lczMaps = glob.glob('data/*/OUTPUT/claMap_cLCZ_22km.tif')
cityCode = []
densityOut = np.zeros((len(path2lczMaps),10))

for idx in range(0,len(path2lczMaps)):
    # get city name
    path = path2lczMaps[idx]
    cityCode.append(path.split('/')[1].split('_')[-1])

    # read lcz and pop data
    popPath = path2lczMaps[idx].replace('OUTPUT/claMap_cLCZ_22km.tif','POP/*POP_22km.tif')
    popPath = glob.glob(popPath)
    fid_lcz = gdal.Open(path)
    lcz = fid_lcz.ReadAsArray()
    fid_pop = gdal.Open(popPath[0])
    pop = fid_pop.ReadAsArray()

    # resample pop data into lcz grid
    tmpPop = imresize(pop,lcz.shape,'nearest')
    pop = tmpPop*np.sum(pop)/np.sum(tmpPop)
    del tmpPop

    # population density on built-up layer
    dst = np.sum(pop[lcz<10])/np.sum(lcz<10)

    # population density per class
    dstPerClass = np.zeros((4))
    dstPerClass[0] = np.sum(pop[lcz==1])/np.sum(lcz==1)
    dstPerClass[1] = np.sum(pop[lcz==6])/np.sum(lcz==6)
    dstPerClass[2] = np.sum(pop[lcz==7])/np.sum(lcz==7)
    dstPerClass[3] = np.sum(pop[lcz==8])/np.sum(lcz==8)
    dstPerClass[np.isnan(dstPerClass)] = 0

    # weighting value: share of population that lives on each class
    dstWeight = np.zeros((4))
    dstWeight[0] = np.sum(pop[lcz==1])/np.sum(pop[lcz<10])
    dstWeight[1] = np.sum(pop[lcz==6])/np.sum(pop[lcz<10])
    dstWeight[2] = np.sum(pop[lcz==7])/np.sum(pop[lcz<10])
    dstWeight[3] = np.sum(pop[lcz==8])/np.sum(pop[lcz<10])

    # weighted population density
    weightDst = np.sum(dstWeight*dstPerClass)

    #
    densityOut[idx,0] = dst
    densityOut[idx,1] = weightDst
    densityOut[idx,2:6] = dstPerClass
    densityOut[idx,6:10] = dstWeight

cityCode = np.array(cityCode)


import csv
with open('cityWeightDensity.csv', 'w') as fp:
    writer = csv.writer(fp, quoting=csv.QUOTE_NONNUMERIC)
    for i in range(0, densityOut.shape[0]):
        tmp = np.array(map(str,densityOut[i])).astype(cityCode.dtype)
        writer.writerow(np.insert(tmp,0,cityCode[i]))







