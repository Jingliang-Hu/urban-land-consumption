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
feat = np.zeros((len(path2lczMaps),15))
cityCode = []
iuIdx = np.triu_indices(5)
for idx in range(0,len(path2lczMaps)):
    path = path2lczMaps[idx]
    cityCode.append(path.split('/')[1])
    tmp = localCooccurance.localCooccurance(path,distArr=[2],angleArr=[0, np.pi/2, np.pi, 3*np.pi/4])
    tmp = np.transpose(np.tril(tmp,-1)) + np.triu(tmp)
    feat[idx] = tmp[iuIdx]

cityCode = np.array(cityCode)

###################################################################################
# PCA feature extraction
scaler = preprocessing.StandardScaler().fit(feat)
featScale = scaler.transform(feat)
pca = PCA(random_state=1)
pca.fit(featScale)
nbComp = np.where(np.cumsum(pca.explained_variance_ratio_)>0.99)
nbComp = nbComp[0][0]+1

pca = PCA(n_components=nbComp,random_state=1)
pca.fit(featScale)
pcs = pca.transform(featScale)


###############################################################################
# find the clustering that has miminum inclass distance

nb_clusters_range = range(2,42);
criterion = np.zeros((43,3))
for nb_clusters in nb_clusters_range:
    # SPECTRAL CLUSTERING
    SCClustering = SpectralClustering(n_clusters=nb_clusters).fit(pcs)
    # Kmean
    KMClustering = KMeans(n_clusters=nb_clusters, random_state=0).fit(pcs)
    # AgglomerativeClustering
    AGClustering = AgglomerativeClustering(n_clusters=nb_clusters).fit(pcs)
    for cv_cluster in range(0,nb_clusters):
        # SPECTRAL CLUSTERING inclass distanc# SPECTRAL CLUSTERING inclass distancee
        tmpFeat = pcs[SCClustering.labels_==cv_cluster,:]
        criterion[nb_clusters,0] = criterion[nb_clusters,0] + np.sum((np.sum(np.square(tmpFeat - np.mean(tmpFeat,axis=0)),axis=1)))
        # Kmean inclass distance
        tmpFeat = pcs[KMClustering.labels_==cv_cluster,:]
        criterion[nb_clusters,1] = criterion[nb_clusters,1] + np.sum((np.sum(np.square(tmpFeat - np.mean(tmpFeat,axis=0)),axis=1)))
        # AgglomerativeClustering inclass distance
        tmpFeat = pcs[AGClustering.labels_==cv_cluster,:]
        criterion[nb_clusters,2] = criterion[nb_clusters,2] + np.sum((np.sum(np.square(tmpFeat - np.mean(tmpFeat,axis=0)),axis=1)))

nb_clusters_range = range(2,43);
plt.figure()
line1 = plt.plot(nb_clusters_range,criterion[2:,0],'r-',label='Spectral clustering')
line2 = plt.plot(nb_clusters_range,criterion[2:,1],'b-',label='K-mean clustering')
line3 = plt.plot(nb_clusters_range,criterion[2:,2],'g-',label='Agglomerative clustering')
plt.legend(loc='upper right')
plt.grid(True)
plt.xlabel('number of clusters')
plt.ylabel('sum of within class distance')
plt.show()


###############################################################################
# set the number of clusters k
# show clustering result
nb_clusters = 7
# Kmean
landUseClustering = KMeans(n_clusters=nb_clusters, random_state=0).fit(pcs)

# get cluster centers
cluster_centers = np.zeros((nb_clusters,feat.shape[1]))
for i in range(0,nb_clusters):
    cluster_centers[i,:] = np.mean(feat[landUseClustering.labels_==i],axis=0)

import csv
with open('occuranceClusterCenter.csv', 'w') as fp:
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








