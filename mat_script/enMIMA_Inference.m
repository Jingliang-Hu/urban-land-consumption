function [flag] = enMIMA_Inference(datTmpDir)

flag = 1;
load(datTmpDir,'OKse2Feat','OKse1Feat','OKmodel')
if ~exist('OKse2Feat','var')
    disp('-------------------------------------------------------------');
    disp('se2 feature missing');
    return
elseif ~exist('OKse1Feat','var')
    disp('-------------------------------------------------------------');
    disp('se1 feature missing')
    return
elseif ~exist('OKmodel','var')
    disp('-------------------------------------------------------------');
    disp('enMIMA model missing')
    return
end

% 
load(datTmpDir,'labCoord','se1dir');

% initial output classification map
[~,ref] = geotiffread(se1dir);
info = geotiffinfo(se1dir);
[firstrow,idxFR]  = min(labCoord(:,3));
[lastrow ,~]  = max(labCoord(:,3));
[firstcol,idxFC]  = min(labCoord(:,4));
[lastcol ,~]  = max(labCoord(:,4));

clamap = zeros(lastrow-firstrow+1,lastcol-firstcol+1,'uint8');

xi = [firstcol - .5, lastcol + .5];
yi = [firstrow - .5, lastrow + .5];
[xlimits, ylimits] = intrinsicToWorld(ref, xi, yi);
subR = ref;
subR.RasterSize = size(clamap);
subR.XLimWorld = sort(xlimits);
subR.YLimWorld = sort(ylimits);
geotiffDir = strrep(datTmpDir,'/datTmp.mat','/claMap_cLCZ.tif');


% load tiles and inferencing
tilePixel = 2000;
[height,width] = size(clamap);

% if the last tile is small, merge it with the second last tile
rowIntvl = [1:tilePixel:height,height+1];
if rowIntvl(end) - rowIntvl(end-1) < tilePixel * 0.1
    rowIntvl(end-1) = [];
end
colIntvl = [1:tilePixel:width,width+1];
if colIntvl(end) - colIntvl(end-1) < tilePixel * 0.1
    colIntvl(end-1) = [];
end
disp('-------------------------------------------------------------');
disp('Loading trained latent space and random forest classifiers')
load(datTmpDir,'maps1','maps2','Mdl_rf')
disp('-------------------------------------------------------------');
disp('Finish loading')

horizonTiles = length(colIntvl)-1;
verticalTiles = length(rowIntvl)-1;
disp('-------------------------------------------------------------');
disp(['The classification map is cut into ', num2str(verticalTiles*horizonTiles),' tiles for inferencing'])

load(datTmpDir,'colStartPoint')

if ~isfile(geotiffDir)
    geotiffwrite(geotiffDir, uint8(clamap), subR, 'GeoKeyDirectoryTag', info.GeoTIFFTags.GeoKeyDirectoryTag);
    colStartPoint = 1;
elseif exist('colStartPoint','var')
    [clamap,~] = geotiffread(geotiffDir);
else
    geotiffwrite(geotiffDir, uint8(clamap), subR, 'GeoKeyDirectoryTag', info.GeoTIFFTags.GeoKeyDirectoryTag);
    colStartPoint = 1;
end
colStart = colStartPoint;
% for loop for tiling and inferencing
disp('-------------------------------------------------------------');
disp('Pointing to the temporary mat file ...')
matObj = matfile(datTmpDir);
disp('-------------------------------------------------------------');
disp('Start inferencing')
for colIdx = colStart:horizonTiles
    se1ColStart = (labCoord(idxFC,4) - 1) + colIntvl(colIdx);
    se1ColEnd   = (labCoord(idxFC,4) - 1) + (colIntvl(colIdx + 1) - 1);

    se2ColStart = (labCoord(idxFC,6) - 1) + colIntvl(colIdx); 
    se2ColEnd   = (labCoord(idxFC,6) - 1) + (colIntvl(colIdx + 1) - 1);
    for rowIdx = 1:verticalTiles
        se1RowStart = (labCoord(idxFR,3) - 1) + rowIntvl(rowIdx);
        se1RowEnd   = (labCoord(idxFR,3) - 1) + (rowIntvl(rowIdx + 1) - 1);

        se2RowStart = (labCoord(idxFR,5) - 1) + rowIntvl(rowIdx);
        se2RowEnd   = (labCoord(idxFR,5) - 1) + (rowIntvl(rowIdx + 1) - 1);
        disp('-------------------------------------------------------------');
        disp(['Loading the ',num2str((colIdx-1)*verticalTiles+rowIdx),' tile'])

        se1Tile = matObj.se1Feat(se1RowStart:se1RowEnd,se1ColStart:se1ColEnd,:);
        se2Tile = matObj.se2Feat(se2RowStart:se2RowEnd,se2ColStart:se2ColEnd,:);
  
        se1Tile = reshape(se1Tile,size(se1Tile,1)*size(se1Tile,2),size(se1Tile,3));
        se2Tile = reshape(se2Tile,size(se2Tile,1)*size(se2Tile,2),size(se2Tile,3));

        disp('parallel inferencing ...')
        % parallel inferencing
        scoEnsemble = zeros(size(se1Tile,1),length(Mdl_rf{1}.ClassNames));
        par = parpool(5);
        par.IdleTimeout = 600;
        parfor cv_m = 1:numel(maps1)
            testFeat = cat(2,se1Tile*maps1{cv_m},se2Tile*maps2{cv_m});
            [~,scores] = predict(Mdl_rf{cv_m},testFeat);
            scoEnsemble = scoEnsemble + scores;
        end
        delete(gcp('nocreate'));
        
        disp('ensembling ...')
        % EnSembling classification results
        [~,pred] = max(scoEnsemble,[],2);
        idCla = cellfun(@str2double,Mdl_rf{1}.ClassNames);
        for i = 1:length(idCla)
            pred(pred==i) = idCla(i);
        end
        disp('write ...')
        clamap(rowIntvl(rowIdx):rowIntvl(rowIdx + 1)-1,colIntvl(colIdx):colIntvl(colIdx + 1)-1) = reshape(uint8(pred),se1RowEnd-se1RowStart+1,se1ColEnd-se1ColStart+1);
        geotiffwrite(geotiffDir, uint8(clamap), subR, 'GeoKeyDirectoryTag', info.GeoTIFFTags.GeoKeyDirectoryTag);
        
    end
    colStartPoint = colIdx + 1;
    save(datTmpDir,'colStartPoint','-append')
end

% save output geotiff
OKclaMap = 1;
save(datTmpDir,'OKclaMap','-append');
disp('-------------------------------------------------------------');
disp('output classification map saved');


end
