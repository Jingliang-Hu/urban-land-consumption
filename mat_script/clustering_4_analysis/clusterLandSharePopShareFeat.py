from src.SDG import localCooccurance
import numpy as np
import glob
import matplotlib.pyplot as plt
from scipy import stats
from sklearn.cluster import MeanShift,SpectralClustering,AgglomerativeClustering,KMeans
from sklearn import preprocessing
from sklearn.decomposition import PCA
from osgeo import gdal




##################################################################################
# extract lcz local cooccurance feature
path2lczMaps = glob.glob('data/*/OUTPUT/claMap_cLCZ_22km.tif')
feat = np.zeros((len(path2lczMaps),10))
dent = np.zeros((len(path2lczMaps),10))

cityCode = []
cityName = []

for idx in range(0,len(path2lczMaps)):
    lczPath = path2lczMaps[idx]
    popPath = lczPath.replace('OUTPUT/claMap_cLCZ_22km.tif','POP/*_22km.tif')
    popPath = glob.glob(popPath)
    popPath = popPath[0]
    cityCode.append(lczPath.split('/')[1])
    cityName.append(lczPath.split('/')[1].split('_')[-1])
    print(cityName[idx])
    feat[idx,:] = localCooccurance.landShareAndPopShareFeat(lczPath,popPath)
    dent[idx,:] = localCooccurance.weightedDensity(lczPath,popPath)


cityCode = np.array(cityCode)
cityName = np.array(cityName)
###################################################################################
# feature scaling
scaler = preprocessing.StandardScaler().fit(feat)
featScale = scaler.transform(feat)

###############################################################################
# find the clustering that has miminum inclass distance

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
line2 = plt.plot(nb_clusters_range,criterion[2:,1],'bx-',label='K-mean clustering')
line3 = plt.plot(nb_clusters_range,criterion[2:,2],'g*-',label='Agglomerative clustering')
plt.legend(loc='upper right')
plt.grid(True)
plt.xlabel('number of clusters')
plt.ylabel('sum of within class distance')
plt.ylabel('sum of squared error')
plt.ylabel('SSE')

plt.show()


###############################################################################
# set the number of clusters k
# show clustering result
nb_clusters = 8
# Kmean
landUseClustering = KMeans(n_clusters=nb_clusters, random_state=0).fit(featScale)

# get cluster centers
cluster_centers = np.zeros((nb_clusters,feat.shape[1]))
for i in range(0,nb_clusters):
    cluster_centers[i,:] = np.mean(feat[landUseClustering.labels_==i],axis=0)

import csv
featToSave = np.concatenate((feat,dent),axis=1)
with open('clusterLandSharePopShareFeat1.csv', 'w') as fp:
    writer = csv.writer(fp, quoting=csv.QUOTE_NONNUMERIC)
    for i in range(0,featToSave.shape[0]):
        tmp = np.array(map(str,np.insert(featToSave[i],20,landUseClustering.labels_[i]))).astype(cityName.dtype)
        writer.writerow(np.insert(tmp,0,cityCode[i]))


with open('clusterLandSharePopShareClusterCenter.csv', 'w') as fp:
    writer = csv.writer(fp, quoting=csv.QUOTE_NONNUMERIC)
    for i in range(0,cluster_centers.shape[0]):
        tmp = np.array(map(str,np.insert(cluster_centers[i],10,i))).astype(cityName.dtype)
        writer.writerow(np.insert(tmp,0,cityCode[i]))







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
# caculate graph
from scipy.spatial.distance import cdist, pdist, squareform
W = pdist(featScale,'euclidean')
W = squareform(W,force='tomatrix')
sortW = np.sort(W)
sortW1 = np.transpose(np.tile(sortW[:,10],(W.shape[1],1)))
A = (W<sortW1)*1
A = ((A+np.transpose(A))>1)*1
np.fill_diagonal(A,0)

import csv
with open('clusterLandSharePopShareGraph.csv', mode='w') as graph_file:
    g_writer = csv.writer(graph_file, delimiter=';', quotechar='"', quoting=csv.QUOTE_MINIMAL)
    for i in range(0,A.shape[0]+1):
        if i==0:
            g_writer.writerow(np.insert(cityName,0,''))
        else:
            tmp = np.array(map(str,A[i-1])).astype(cityName.dtype)
            g_writer.writerow(np.insert(tmp,0,cityName[i-1]))








