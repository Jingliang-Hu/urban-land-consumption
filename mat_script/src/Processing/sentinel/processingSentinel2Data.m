%% preprocessing sentinel 2 data
% %
% 1. mosaicing adjacent data set
%
% %
% 2. resample to 10 meter resolution
%

%% mosaicing
dataPath1 = 'D:\Original_test_data\sentinel\sentinel_2\munich\tiles_32_U_PU_2017_4_24_0\';
dataPath2 = 'D:\Original_test_data\sentinel\sentinel_2\munich\tiles_32_U_QU_2017_4_24_0\';
savePath = 'D:\Original_test_data\sentinel\sentinel_2\munich';

[R] = mosaic( dataPath1,dataPath2,savePath );


%% resampling
resampleSentinel2( 'D:\Original_test_data\sentinel\sentinel_2\munich\mosaic' );


%% rgb

