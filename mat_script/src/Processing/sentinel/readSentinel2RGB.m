% read sentinel 2 rgb bands

path = 'D:\Original_test_data\sentinel\sentinel_2\mumbai\tiles_43_Q_BB_2016_11_24_0\';

[r] = imread([path,'B02.jp2']);
[g] = imread([path,'B03.jp2']);
[b] = imread([path,'B04.jp2']);

rgb = cat(3,r,g,b);

[ rgb ] = sentinel2RGB( rgb );