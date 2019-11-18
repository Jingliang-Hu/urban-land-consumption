function [ pcs ] = pca_dr( varargin )
%dimension reduction using principle component analysis
%   -- input:
%       -- data         -- input data; row: observations; column: features
%       -- dim          -- criteria for dimension reduction
%   -- output:
%       -- pcs          -- dimension reduced data



data = varargin{1};
dim = 0.99;
n = 2;
[r,c,d] = size(data);
if d > 1
    data = reshape(data,r*c,d);
end

while n < nargin
    switch lower(varargin{n})
        case 'criteria'
            n = n + 1;
            dim = varargin{n};                 
    end
    n = n + 1;
end

[~,pcs,latent,~,pbl,~]=pca(data);

cumpb = cumsum(pbl);

if ~ischar(dim) && dim > 1
    pcs = pcs(:,1:dim);
elseif  ~ischar(dim) && dim > 0 && dim <= 1
    loc = find(cumpb >= dim*100,1);
    pcs = pcs(:,1:loc);
elseif strcmpi(dim,'one')
    pcs = pcs(:,1);
end


dd = size(pcs,2);
if d > 1
    pcs = reshape(pcs,r,c,dd);
end

end

