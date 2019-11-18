function [ feat ] = gaborfeat( varargin )
%extract texture information using gabor filter
%   - Input:
%       -- data          -- input data
%       -- angle         -- direction of feature extraction
%       -- scale         -- extent
% 
%   - Output:
%       -- feat          -- extracted textures
%
%   call of the function : [ feat ] = gaborfeat( data,'angle',anglearr,'scale',scalearr );

%% read input variables
data = varargin{1};
n = 2;
direction = 0;
scale = 13;
while n < nargin
    switch lower(varargin{n})
        case 'angle'
            n = n + 1;
            direction = varargin{n};            
        case 'scale'
            n = n + 1;
            scale = varargin{n};    
    end
    n = n + 1;
end

%% initialize the output
nb_angle = length(direction);
nb_scale = length(scale);
[r,c,d] = size(data);
feat = zeros(r,c,d*nb_angle*nb_scale*2);

%% extracting features
pos_phase = (d*nb_angle*nb_scale*2)/2;
for dd = 1:d
    for sc = 1:nb_scale
        for ag = 1:nb_angle % loop of angles
            [r2,x2]=Gaborforfolder(data(:,:,dd),direction(ag),scale(sc));
%             f2=complex(r2,x2);
            feat(:,:,(dd-1)*(nb_scale*nb_angle)+(sc-1)*nb_angle+ag) = r2;
            feat(:,:,(dd-1)*(nb_scale*nb_angle)+(sc-1)*nb_angle+ag+pos_phase) = x2;

        end
    end
end





end

