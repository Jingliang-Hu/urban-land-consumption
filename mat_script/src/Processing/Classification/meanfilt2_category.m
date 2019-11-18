function [ m_img ] = meanfilt2_category( img,W )
%The function of meanfilt2 implies spatial averaging to the 'img' using a
%window size of (2*W+1) * (2*W+1)
%   Input   -- img       - PolSAR image to be filtered
%           -- W         - averaging window size (2*W+1) * (2*W+1)
%
%   Output  -- m_img     - filtered image

padData = padarray(img,[W,W],'symmetric','both');
[rw,cl,~] = size(padData);
temp = zeros(rw,cl,(2*W+1)^2);


for i = -W:W
    for j = -W:W
        temp(:,:,(i+1)*(2*W+1)+j+2) = circshift(padData,[i,j]);
    end
end
m_img = mode(temp,3);

m_img = m_img(W+1:end-1,W+1:end-1,:);
end
