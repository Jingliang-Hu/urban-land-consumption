function [ se1Feat ] = sen1FeatExtractMem( path, datTmpPath )
%This function extracts features from the Sentinel-1 data
%   - Input:
%       - path              -- directory to a sentinel-1 geotiff file
%       - datTmpPath        -- directory to a mat temporary data file
%   - Output:
%       - se1Feat           -- extracted PolSAR feature
if isfile(datTmpPath)
    load(datTmpPath,'se1BndProcessed');
end
if ~exist('se1BndProcessed','var')
    % set the directory to a temporary file for data saving
    info = geotiffinfo(path);

    se1Feat = zeros(info.Height,info.Width,36,'single');
    if isfile(datTmpPath)
        save(datTmpPath,'se1Feat','-append');
    else
        save(datTmpPath,'se1Feat','-v7.3');
    end

    % tiling parameter
    tilePixel = 2000;
    bufferPixel = 500;
    width = info.Width;
    height = info.Height;

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

    % read data from geotiff file
    [polsar,~]=geotiffread(path);
    if ~isa(polsar,'single')
        polsar = single(polsar);
    end
  
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
            [ se1FeatTile ] = sen1Feature( polsar(rowStart:rowEnd,colStart:colEnd,:));

            % put feature tile into one piece
            rowTileStart = bufferPixel+1;
            rowTileEnd   = size(se1FeatTile,1)-bufferPixel;
            colTileStart = bufferPixel+1;
            colTileEnd   = size(se1FeatTile,2)-bufferPixel;
            if colIdx == 1
                colTileStart = 1;
            end
            if colIdx == horizonTiles
                colTileEnd   = size(se1FeatTile,2);
            end
            if rowIdx == 1
                rowTileStart = 1;
            end
            if rowIdx == verticalTiles
                rowTileEnd   = size(se1FeatTile,1);
            end

            matObj.se1Feat(rowIntvl(rowIdx):rowIntvl(rowIdx+1),colIntvl(colIdx):colIntvl(colIdx+1),:) = se1FeatTile(rowTileStart:rowTileEnd,colTileStart:colTileEnd,:);
            disp(['The ',num2str((colIdx-1)*verticalTiles+rowIdx),' tile is saved ...'])
        end
    end
    clear matObj
end

[~] = se1Processing(datTmpPath);
disp('The feature preprocessing is done ...')
se1Feat = 0;
end

function[se1Feat] = sen1Feature( polsarTile )

polsarTile = cat(3,polsarTile(:,:,1),polsarTile(:,:,4),polsarTile(:,:,2:3));
% extract data mask
mask = sum(polsarTile,3)==0;
% coherence of VV and VH
coh = sqrt(polsarTile(:,:,3).^2+polsarTile(:,:,4).^2)./sqrt(polsarTile(:,:,1).*polsarTile(:,:,2));
coh(mask) = 0;
% ratio of VV and VH
ratio = (polsarTile(:,:,1)./polsarTile(:,:,2));
ratio(mask) = 0;
PolFeat = cat(3,polsarTile(:,:,1:2),ratio,coh);

PolFeat(isnan(PolFeat(:)))=0;
PolFeat(isinf(PolFeat(:)))=0;

%% morphological profile
r1 = 1:3;
r2 = r1;
options = 'MPr';
temp=[];
for i=1:size(PolFeat,3)
   MPNeachpca = Make_Morphology_profile(PolFeat(:,:,i),r1,r2,options);
   temp = cat(3,temp,MPNeachpca);        
end

%% statistics
% 'localStat_mov' is faster and less memory demanding than 'localStat_f'
[ featMean ] = localStat_mov( PolFeat,5,'mean' );
[ featStd ]  = localStat_mov( PolFeat,5,'std' );

se1Feat = cat(3,temp,featMean,featStd);   

end

function [flag] = se1Processing(matPath)
% convert to dB, and mean-std normalization
disp('Sentinel-1 preprocessing starts ...')
load(matPath,'se1BndProcessed');
if exist('se1BndProcessed','var')
    bndStart = se1BndProcessed;    
else
    bndStart = 1;    
end
matObj = matfile(matPath,'Writable',true); 

dBbnd = [1:21,29:31,33:35];
numbnd = 36;
for se1BndProcessed = bndStart:numbnd
    tmp = matObj.se1Feat(:,:,se1BndProcessed);
    if sum(se1BndProcessed==dBbnd)
        tmp = log10(tmp);
    end
    matObj.se1Feat(:,:,se1BndProcessed) = zscore(tmp);    
    save(matPath,'se1BndProcessed','-append');
    disp(['The ',num2str(se1BndProcessed),'th band is preprocessed'])
end
flag = 0;

end

