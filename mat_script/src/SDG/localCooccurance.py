from osgeo import gdal
import numpy as np
from skimage.feature import greycomatrix
from scipy.misc import imresize

def loadTif(path):
# load geotiff into mem
    fid = gdal.Open(path)
    dat = fid.ReadAsArray();
    return dat

def popShare(pop,lcz):
    popShareFeat = np.zeros((1,5))
    popShareFeat[0,0] = np.sum(pop[lcz==1])/np.sum(pop[lcz<107])
    popShareFeat[0,1] = np.sum(pop[lcz==6])/np.sum(pop[lcz<107])
    popShareFeat[0,2] = np.sum(pop[lcz==7])/np.sum(pop[lcz<107])
    popShareFeat[0,3] = np.sum(pop[lcz==8])/np.sum(pop[lcz<107])
    popShareFeat[0,4] = np.sum(pop[(lcz>10)&(lcz<107)])/np.sum(pop[lcz<107])
    return popShareFeat

def landShare(lcz):
    landShareFeat = np.zeros((1,5))
    landShareFeat[0,0] = np.sum(lcz==1).astype(np.single)/np.sum(lcz<107)
    landShareFeat[0,1] = np.sum(lcz==6).astype(np.single)/np.sum(lcz<107)
    landShareFeat[0,2] = np.sum(lcz==7).astype(np.single)/np.sum(lcz<107)
    landShareFeat[0,3] = np.sum(lcz==8).astype(np.single)/np.sum(lcz<107)
    landShareFeat[0,4] = np.sum((lcz>10)&(lcz<107)).astype(np.single)/np.sum(lcz<107)
    return landShareFeat

def landShareAndPopShareFeat(lczPath,popPath):
    pop = loadTif(popPath)
    lcz = loadTif(lczPath)
    poptmp = imresize(pop,lcz.shape,'nearest')
    pop = poptmp*np.sum(pop)/np.sum(poptmp)
    del poptmp

    landShareFeat = landShare(lcz)
    popShareFeat = popShare(pop,lcz)
    feat = np.concatenate((landShareFeat, popShareFeat),axis=1)
    return feat


def weightedDensity(lczPath,popPath):
    pop = loadTif(popPath)
    lcz = loadTif(lczPath)
    poptmp = imresize(pop,lcz.shape,'nearest')
    pop = poptmp*np.sum(pop)/np.sum(poptmp)
    del poptmp

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
    densityOut = np.zeros((10))
    densityOut[0] = dst
    densityOut[1] = weightDst
    densityOut[2:6] = dstPerClass
    densityOut[6:10] = dstWeight
    return densityOut




def datRefineForSDG(lcz):
    lcz[lcz==6] = 2 
    lcz[lcz==7] = 3
    lcz[lcz==8] = 4
    lcz[lcz>10] = 5
    return lcz-1

def cooccuranceFeat(dat,distArr=[2],angleArr=[0, np.pi/2, np.pi, 3*np.pi/4]):
    cooccurance = greycomatrix(dat, distArr, angleArr,levels=np.max(dat)+1)
    feat = np.sum(cooccurance,axis=3)
    feat = np.sum(feat,axis=2)
    return feat

def localCooccurance(path,distArr=[2],angleArr=[0, np.pi/2, np.pi, 3*np.pi/4]):
    lcz = loadTif(path)
    lcz = datRefineForSDG(lcz)
    feat = cooccuranceFeat(lcz,distArr,angleArr)
    return feat

