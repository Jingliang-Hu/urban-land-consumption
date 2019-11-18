function [ data,r ] = readLandSat( path )
%UNTITLED2 Summary of this function goes here
%   Detailed explanation goes here

binfiles = dir([path,'\*.tif']);
temp = cell(1,length(binfiles));
for i = 1:length(binfiles)
     [temp{i},r] = geotiffread([binfiles(i).folder,'\',binfiles(i).name]);
end
data = cat(3,temp{:});


end

