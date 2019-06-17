function [ se2Feat ] = sen2FeatExtractMem( path, datTmpPath )
%This function extracts features from the Sentinel-2 data
%   - Input:
%       - path              -- directory to a sentinel-2 geotiff file
%       - datTmpPath        -- directory to a mat temporary data file
%   - Output:
%       - se2Feat           -- extracted sentinel-2 feature

load(datTmpPath,'se2BndProcessed');
if ~exist('se2BndProcessed','var')
    % read data from geotiff file
    [MSI,~]=geotiffread(path);
    MSI = MSI(:,:,1:12);
    sz = size(MSI);

    % extract data mask
    mask = sum(MSI,3)==0;

    % apply pca on data
    dataTmp = reshape(MSI,sz(1)*sz(2),sz(3));clear MSI
    dataTmp = dataTmp(~mask(:),:);
    dataTmp = pca_dr(double(dataTmp));

    % % previous code signed dataTmp as double. Result might differ
    if ~isa(dataTmp,'single')
        dataTmp = single(dataTmp);
    end
    s2data = zeros(sz(1)*sz(2),size(dataTmp,2),'single');
    s2data(~mask,:) = dataTmp; clear dataTmp
    s2data = reshape(s2data,sz(1),sz(2),size(s2data,2));
    sz = size(s2data);
    se2Feat = zeros(sz(1),sz(2),sz(3)*7,'single');

    % set the directory to a temporary file for data saving
    if isfile(datTmpPath)
        save(datTmpPath,'se2Feat','-append');
    else
        save(datTmpPath,'se2Feat','-v7.3');
    end

    % tiling parameter
    tilePixel = 2000;
    bufferPixel = 500;
    width = sz(2);
    height = sz(1);

    % if the last tile is small, merge it with the second last tile
    rowIntvl = [1:tilePixel:height,height];
    if rowIntvl(end) - rowIntvl(end-1) < tilePixel * 0.1 || rowIntvl(end) - rowIntvl(end-1) < bufferPixel
        rowIntvl(end-1) = [];
    end
    colIntvl = [1:tilePixel:width,width];
    if colIntvl(end) - colIntvl(end-1) < tilePixel * 0.1 || colIntvl(end) - colIntvl(end-1) < bufferPixel
        colIntvl(end-1) = [];
    end

    horizonTiles = length(colIntvl)-1;
    verticalTiles = length(rowIntvl)-1;

    disp(['The data is cut into ', num2str(verticalTiles*horizonTiles),' tiles'])



    matObj = matfile(datTmpPath,'Writable',true); 
    for colIdx = 1:horizonTiles
        % get the columns of the tile
        colStart = colIntvl(colIdx) - bufferPixel;
        colEnd   = colIntvl(colIdx + 1) + bufferPixel;
        if colIdx == 1
            colStart = 1;
        end
        if colIdx == horizonTiles
            colEnd = width;
        end

        for rowIdx = 1:verticalTiles
            disp(['The ',num2str((colIdx-1)*verticalTiles+rowIdx),' tile is under processing ...'])
            % get the rows of the tile
            rowStart = rowIntvl(rowIdx) - bufferPixel;
            rowEnd   = rowIntvl(rowIdx + 1) + bufferPixel;
            if rowIdx == 1
                rowStart = 1;
            end
            if rowIdx == verticalTiles
                rowEnd = height;
            end

            % feature extraction of the tile
            [ se2FeatTile ] = sen2Feature( s2data(rowStart:rowEnd,colStart:colEnd,:));

            % put feature tile into one piece
            rowTileStart = bufferPixel+1;
            rowTileEnd   = size(se2FeatTile,1)-bufferPixel;
            colTileStart = bufferPixel+1;
            colTileEnd   = size(se2FeatTile,2)-bufferPixel;
            if colIdx == 1
                colTileStart = 1;
            end
            if colIdx == horizonTiles
                colTileEnd   = size(se2FeatTile,2);
            end
            if rowIdx == 1
                rowTileStart = 1;
            end
            if rowIdx == verticalTiles
                rowTileEnd   = size(se2FeatTile,1);
            end

            matObj.se2Feat(rowIntvl(rowIdx):rowIntvl(rowIdx+1),colIntvl(colIdx):colIntvl(colIdx+1),:) = se2FeatTile(rowTileStart:rowTileEnd,colTileStart:colTileEnd,:);
            disp(['The ',num2str((colIdx-1)*verticalTiles+rowIdx),' tile is saved ...'])
        end
    end
    clear matObj
end
    
    
[~] = se2Processing(datTmpPath);
disp('The feature preprocessing is done ...')
se2Feat = 0;
end


function [ se2Feat ] = sen2Feature( dataTile )
%This function extracts features from the Sentinel-2 data
%   - Input:
%       - datatile          -- directory to a sentinel-2 geotiff file
%   - Output:
%       - se2Feat           -- extracted sentinel-2 feature

% morphological profile on pcs
r1 = 1:3;
r2 = r1;
options = 'MPr';
se2Feat=[];
for i=1:size(dataTile,3)
   MPNeachpca = Make_Morphology_profile(dataTile(:,:,i),r1,r2,options);
   se2Feat = cat(3,se2Feat,MPNeachpca);        
end

end


function [flag] = se2Processing(matPath)
% mean-std normalization
disp('Sentinel-2 normalization starts ...')
load(matPath,'se2BndProcessed');
if exist('se2BndProcessed','var')
    bndStart = se2BndProcessed;    
else
    bndStart = 1;   
end

matObj = matfile(matPath,'Writable',true); 
numbnd = size(matObj.se2Feat,3);

for se2BndProcessed = bndStart:numbnd
    tmp = matObj.se2Feat(:,:,se2BndProcessed);    
    matObj.se2Feat(:,:,se2BndProcessed) = zscore(tmp);    
    save(matPath,'se2BndProcessed','-append');
    disp(['The ',num2str(se2BndProcessed),'th band is normalized'])
end
flag = 0;

end
