labelDir = 'D:\Matlab\SDG\data\munich\GT\munich_lcz_GT_train.tif';
se1Dir = 'D:\Matlab\SDG\data\munich\SE1\S1B_IW_SLC__1SDV_20170609T052529_20170609T052557_005969_00A798_1958_Orb_Cal_Deb_Spk_TC_SUB.tif';
se2Dir = 'D:\Matlab\SDG\data\munich\SE2\204371_summer_1.tif';
patchSize = 0;

% load the real world label coordinate
[ coord, label, EPSG ] = getCoordAndLabel( labelDir );

% delete the labels outside SE1 data
[ coord, label] = deleteLabelOutDataExtent(coord, label, se1Dir, EPSG);

% delete the labels outside SE2 data
[ coord, label] = deleteLabelOutDataExtent(coord, label, se2Dir, EPSG);

% get the image coordinates of label in SEN1 data
[ imCoord ] =  getImCoord(se1Dir, coord, EPSG, 's1');

% get the image coordinates of label in SEN2 data
[ imCoord_tmp ] =  getImCoord(se2Dir, coord, EPSG, 's2');
imCoord(:,5:6) = imCoord_tmp(:,5:6); clear imCoord_tmp

% get the SEN1 data mask
[ mask ] = getDataMaskSEN1(se1Dir, patchSize);

% delete the labels locates in no data area of SEN1
[ imCoord, label ] = deleteLabelOutDataMask(imCoord, label, mask, 's1', patchSize);

% get the SEN2 data mask
[ mask ] = getDataMaskSEN2(se2Dir, patchSize);

% delete the labels locates in no data area of SEN2
[ imCoord, label ] = deleteLabelOutDataMask(imCoord, label, mask, 's2', patchSize);

