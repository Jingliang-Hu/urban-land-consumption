function [ m_img ] = meanfilt2( img,W )
%The function of meanfilt2 implies spatial averaging to the 'img' using a
%window size of (2*W+1) * (2*W+1)
%   Input   -- img       - PolSAR image to be filtered
%           -- W         - averaging window size (2*W+1) * (2*W+1)
%
%   Output  -- m_img     - filtered image

[rw,cl,dn] = size(img);
temp = zeros(rw,cl,dn);
for i = -W:W
    for j = -W:W
        temp = temp + circshift(img,[i,j]);
    end
end
m_img = temp./(2*W+1)^2;
end
