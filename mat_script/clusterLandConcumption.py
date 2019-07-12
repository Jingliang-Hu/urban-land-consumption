import matplotlib.pyplot as plt
import scipy.io as sio
import numpy as np
import glob

from osgeo import gdal
from scipy import stats
from sklearn.cluster import MeanShift,SpectralClustering,AgglomerativeClustering,KMeans
from sklearn import preprocessing

###########################################################################
# load data

matFiles = glob.glob('data/*/OUTPUT/SDG_STAT.mat')
nbCity = len(matFiles)
# the order of cities
cityOrder = []
"""
land comsuption features
"""
# the shares of land that in different categories
landShare = np.zeros((nbCity,5))
# the shares of population that live in different land categories
landPopShare = np.zeros((nbCity,5))

for idx in range(0,nbCity):
    matTmp = sio.loadmat(matFiles[idx])
    # load city order
    cityOrder.append(str(matTmp['cityCode'][0]))
    # land comsuption feature
    landShare[idx,:] = np.array(matTmp['landStat'][0,:])
    landPopShare[idx,:] = np.array(matTmp['landStat'][1,:])

cityOrder = np.array(cityOrder)




###############################################################################
# clustering land consumption
feat = landShare.copy()
scaler = preprocessing.StandardScaler().fit(feat)
featScale = scaler.transform(feat)  
nb_clusters = 6 
# MEANSHIFT
# landUseClustering = MeanShift().fit(featScale)
# SPECTRAL CLUSTERING
landUseClustering = SpectralClustering(n_clusters=nb_clusters).fit(featScale)
# Kmean
landUseClustering = KMeans(n_clusters=nb_clusters, random_state=0).fit(featScale)
# AgglomerativeClustering
landUseClustering = AgglomerativeClustering(n_clusters=nb_clusters).fit(featScale)

modeClusters = stats.mode(landUseClustering.labels_)
nbClusters = np.size(np.unique(landUseClustering.labels_))
plt.figure()
for cv_Cluster in range(0,nbClusters):
    cityInCluster = cityOrder[np.array(landUseClustering.labels_==cv_Cluster)]
    for cv_in_cluster in range(0,cityInCluster.size):
        lczColDir = 'data/'+cityInCluster[cv_in_cluster]+'/OUTPUT/claMap_cLCZ_22km_col.tif'
        fid = gdal.Open(lczColDir)
        lczCol = np.array(fid.ReadAsArray())
        lczCol = np.transpose(lczCol,(1,2,0))
        ax = plt.subplot(nbClusters, modeClusters.count[0], cv_Cluster*modeClusters.count[0]+cv_in_cluster+1)
        titleCity = cityInCluster[cv_in_cluster].split('_')
        ax.set_title(titleCity[-1])
        ax.axis('off')
        plt.imshow(lczCol)

plt.show()

###############################################################################
# clustering population on land consumption
feat = landPopShare.copy()
scaler = preprocessing.StandardScaler().fit(feat)
featScale = scaler.transform(feat)
nb_clusters = 5
# MEANSHIFT
# landUseClustering = MeanShift().fit(featScale)
# SPECTRAL CLUSTERING
landUseClustering = SpectralClustering(n_clusters=nb_clusters).fit(featScale)
# Kmean
landUseClustering = KMeans(n_clusters=nb_clusters, random_state=0).fit(featScale)
# AgglomerativeClustering
landUseClustering = AgglomerativeClustering(n_clusters=nb_clusters).fit(featScale)

modeClusters = stats.mode(landUseClustering.labels_)
nbClusters = np.size(np.unique(landUseClustering.labels_))
plt.figure()
for cv_Cluster in range(0,nbClusters):
    cityInCluster = cityOrder[np.array(landUseClustering.labels_==cv_Cluster)]
    for cv_in_cluster in range(0,cityInCluster.size):
        lczColDir = 'data/'+cityInCluster[cv_in_cluster]+'/OUTPUT/claMap_cLCZ_22km_col.tif'
        fid = gdal.Open(lczColDir)
        lczCol = np.array(fid.ReadAsArray())
        lczCol = np.transpose(lczCol,(1,2,0))
        ax = plt.subplot(nbClusters, modeClusters.count[0], cv_Cluster*modeClusters.count[0]+cv_in_cluster+1)
        ax.set_title(cityInCluster[cv_in_cluster].replace('_',' '))
        ax.axis('off')
        plt.imshow(lczCol)

plt.show()



