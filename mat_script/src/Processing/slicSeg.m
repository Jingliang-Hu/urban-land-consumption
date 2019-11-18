function [ segmentsSLIC ] = slicSeg( varargin )
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here

im = varargin{1};
show = 0;
if nargin == 2
    show = varargin{2};
end


% % slic parameter setting
regionSize = 10 ;
regularizer = 0.01;
tic
segmentsSLIC = vl_slic(single(uint8(im)), regionSize, regularizer) ;
segmentsSLIC = segmentsSLIC + 1;
toc
segIdx = unique(segmentsSLIC(:));
if length(segIdx) ~= max(segIdx)
    ind = segIdx(2:end) - segIdx(1:end-1);
    ind = find(ind~=1);
    for i = 1:length(ind)
        segmentsSLIC(segmentsSLIC > ind(i)) = segmentsSLIC(segmentsSLIC > ind(i))-1;
    end
end

if show == 1
    
    [sx,sy]=vl_grad(double(segmentsSLIC), 'type', 'forward') ;
    s = find(sx | sy) ;
    im_slic = im ;
    d = size(im,3);
    if d == 3
        im_slic([s s+numel(im(:,:,1)) s+2*numel(im(:,:,1))]) = 0 ;
    elseif d == 1
        im_slic(s) = 0 ;
    end
    figure,imshow(im_slic);
end


end

