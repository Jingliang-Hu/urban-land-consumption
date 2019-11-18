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
cityCode = []
"""
land comsuption features
"""
# the shares of land that in different categories
landShare = np.zeros((nbCity,5))
# the shares of population that live in different land categories
landPopShare = np.zeros((nbCity,5))
# the shares of land that in different categories
land = np.zeros((nbCity,5))
# the shares of population that live in different land categories
landPop = np.zeros((nbCity,5))



# the total population
popTotal = np.zeros((nbCity,1))

for idx in range(0,nbCity):
    matTmp = sio.loadmat(matFiles[idx])
    # load city order
    cityCode.append(str(matTmp['cityCode'][0]))
    cityOrder.append(str(matTmp['cityCode'][0]).split('_')[-1])
    # land comsuption feature
    landShare[idx,:] = np.array(matTmp['landStat'][0,:])
    landPopShare[idx,:] = np.array(matTmp['landStat'][1,:])
    land[idx,:] = np.array(matTmp['landStat'][2,:])
    landPop[idx,:] = np.array(matTmp['landStat'][3,:])
    popTotal[idx] = matTmp['popTotal'][0][0]

cityOrder = np.array(cityOrder)
cityCode  = np.array(cityCode)

##############################################################################
# visualize the data

plt.figure()
for idx in range(0,5):
    ax = plt.subplot(2,5,idx+1)
#    plt.plot(landPop[:,idx])
    plt.bar(cityOrder,landPop[:,idx])
    ax = plt.subplot(2,5,idx+6)
    plt.plot(landPopShare[:,idx])

plt.show()

import csv
with open('popOnLandFeat.csv', 'w') as fp:
    writer = csv.writer(fp, quoting=csv.QUOTE_NONNUMERIC)
    for i in range(0,landPop.shape[0]):
        tmp = np.concatenate((landPop[i,:],landPopShare[i,:]),axis=0)
        tmp = np.array(map(str,tmp)).astype(cityOrder.dtype)
        writer.writerow(np.insert(tmp,0,cityOrder[i]))




###############################################################################
# set the feature
feat = np.zeros(land.shape)
feat[land>0] = landPop[land>0]/land[land>0]
scaler = preprocessing.StandardScaler().fit(feat)
featScale = scaler.transform(feat)


###############################################################################
# find the number of clusters 
nb_clusters_range = range(2,42);
criterion = np.zeros((43,3))
for nb_clusters in nb_clusters_range:
    # SPECTRAL CLUSTERING
    SCClustering = SpectralClustering(n_clusters=nb_clusters).fit(featScale)
    # Kmean
    KMClustering = KMeans(n_clusters=nb_clusters, random_state=0).fit(featScale)
    # AgglomerativeClustering
    AGClustering = AgglomerativeClustering(n_clusters=nb_clusters).fit(featScale)
    for cv_cluster in range(0,nb_clusters):
        # SPECTRAL CLUSTERING inclass distanc# SPECTRAL CLUSTERING inclass distancee
        tmpFeat = featScale[SCClustering.labels_==cv_cluster,:]
        criterion[nb_clusters,0] = criterion[nb_clusters,0] + np.sum((np.sum(np.square(tmpFeat - np.mean(tmpFeat,axis=0)),axis=1)))
        # Kmean inclass distance
        tmpFeat = featScale[KMClustering.labels_==cv_cluster,:]
        criterion[nb_clusters,1] = criterion[nb_clusters,1] + np.sum((np.sum(np.square(tmpFeat - np.mean(tmpFeat,axis=0)),axis=1)))
        # AgglomerativeClustering inclass distance
        tmpFeat = featScale[AGClustering.labels_==cv_cluster,:]
        criterion[nb_clusters,2] = criterion[nb_clusters,2] + np.sum((np.sum(np.square(tmpFeat - np.mean(tmpFeat,axis=0)),axis=1)))

nb_clusters_range = range(2,43);
plt.figure()
line1 = plt.plot(nb_clusters_range,criterion[2:,0],'ro-',label='Spectral clustering')
line2 = plt.plot(nb_clusters_range,criterion[2:,1],'b*-',label='K-mean clustering')
line3 = plt.plot(nb_clusters_range,criterion[2:,2],'gx-',label='Agglomerative clustering')
plt.legend(loc='upper right')
plt.grid(True)
plt.xlabel('number of clusters')
plt.ylabel('sum of within class distance')
plt.show()




###############################################################################
# set the number of clusters k
# show clustering result
nb_clusters = 6
# Kmean
landUseClustering = KMeans(n_clusters=nb_clusters, random_state=0).fit(featScale)
# get cluster centers
cluster_centers = np.zeros((nb_clusters,feat.shape[1]))
for i in range(0,nb_clusters):
    cluster_centers[i,:] = np.mean(feat[landUseClustering.labels_==i],axis=0)

import csv
with open('popOnLandCenter.csv', 'w') as fp:
    writer = csv.writer(fp, quoting=csv.QUOTE_NONNUMERIC)
    for i in range(0,cluster_centers.shape[0]):
        writer.writerow(cluster_centers[i,:])





##
modeClusters = stats.mode(landUseClustering.labels_)
nbClusters = np.size(np.unique(landUseClustering.labels_))
plt.figure()
for cv_Cluster in range(0,nbClusters):
    cityInCluster = cityCode[np.array(landUseClustering.labels_==cv_Cluster)]
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
# VISUALIZATION PREPARATION
# produce the graph to represent the latent space of proximity
# the graph is represented by a 42 by 42 matrix

graphMat = np.zeros((42,42),dtype=np.uint8)
for nb_clusters in range(2,43):
# MEANSHIFT
# landUseClustering = MeanShift().fit(featScale)
# SPECTRAL CLUSTERING
# landUseClustering = SpectralClustering(n_clusters=nb_clusters).fit(featScale)
    # Kmean
    landUseClustering = KMeans(n_clusters=nb_clusters, random_state=0).fit(featScale)
    w = np.tile(landUseClustering.labels_,(42,1))==np.transpose(np.tile(landUseClustering.labels_,(42,1)))
    graphMat = graphMat + w.astype(np.uint8)
    # AgglomerativeClustering
    landUseClustering = AgglomerativeClustering(n_clusters=nb_clusters).fit(featScale)
    w = np.tile(landUseClustering.labels_,(42,1))==np.transpose(np.tile(landUseClustering.labels_,(42,1)))
    graphMat = graphMat + w.astype(np.uint8)

np.fill_diagonal(graphMat,0)


import csv
with open('popGraph.csv', mode='w') as graph_file:
    g_writer = csv.writer(graph_file, delimiter=';', quotechar='"', quoting=csv.QUOTE_MINIMAL)
    for i in range(0,graphMat.shape[0]+1):
        if i==0:
            g_writer.writerow(np.insert(cityOrder,0,''))
        else:
            tmp = np.array(map(str,graphMat[i-1])).astype(cityOrder.dtype)
            g_writer.writerow(np.insert(tmp,0,cityOrder[i-1]))


with open('popFeat.csv', mode='w') as graph_file:
    g_writer = csv.writer(graph_file, delimiter=';', quotechar='"', quoting=csv.QUOTE_MINIMAL)
    for i in range(0,feat.shape[0]):
        tmp = np.array(map(str,feat[i])).astype(cityOrder.dtype)
        g_writer.writerow(np.insert(tmp,0,cityOrder[i]))



"""

with open('landFeature.csv', mode='w') as graph_file:
    g_writer = csv.writer(graph_file, delimiter=';', quotechar='"', quoting=csv.QUOTE_MINIMAL)
    for i in range(0,landShare.shape[0]):
        tmp = np.array(map(str,landShare[i])).astype(cityOrder.dtype)
        g_writer.writerow(np.insert(tmp,0,cityOrder[i]))


with open('popFeature.csv', mode='w') as graph_file:
    g_writer = csv.writer(graph_file, delimiter=';', quotechar='"', quoting=csv.QUOTE_MINIMAL)
    for i in range(0,landPopShare.shape[0]):
        tmp = np.array(map(str,landPopShare[i])).astype(cityOrder.dtype)
        g_writer.writerow(np.insert(tmp,0,cityOrder[i]))


"""


