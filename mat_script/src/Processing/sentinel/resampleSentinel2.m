function [  ] = resampleSentinel2( path )
%UNTITLED3 Summary of this function goes here
%   Detailed explanation goes here


% new folder for resampled data
if exist([path,'\resample'], 'file') == 0
    mkdir([path,'\resample']);
end


% file name of each band
fileNames = {'B01.jp2','B02.jp2','B03.jp2','B04.jp2','B05.jp2','B06.jp2','B07.jp2','B08.jp2','B09.jp2','B10.jp2','B11.jp2','B12.jp2','B8A.jp2'};


% resolution of band [1,2,3,... ,12,B8A]
resolutionIdx = [60,10,10,10,20,20,20,10,60,60,20,20,20];



for i = 1:length(resolutionIdx)
    temp = imread([path,'\',fileNames{i}]);
    if resolutionIdx(i) == 60
        im = imresize(temp,6,'nearest');
    elseif resolutionIdx(i) ==20
        im = imresize(temp,2,'nearest');
    end  
    writeFile = [path,'\resample\',fileNames{i}];
    imwrite(im,writeFile);
end

end

