function [ C2 ] = readSEN1UnfltBinary( varargin )
%UNTITLED3 Summary of this function goes here
%   Detailed explanation goes here


% path = 'E:\So2Sat\data\massive_downloading\0378_index_0033_Adelaide\original_dat\201706\Subset_S1A_IW_SLC__1SDV_20170607T200453_20170607T200519_016932_01C2E2_7E63_Orb_Cal_Deb.data'

path = varargin{1};
fileName = {'\i_VH.img','\q_VH.img','\i_VV.img','\q_VV.img'};


switch nargin
    case 1
        [i_vh,~] = readHSI_data([path,fileName{1}],'.img');
        [q_vh,~] = readHSI_data([path,fileName{2}],'.img');
        [i_vv,~] = readHSI_data([path,fileName{3}],'.img');
        [q_vv,~] = readHSI_data([path,fileName{4}],'.img');
    case 2
        [i_vh,~] = readHSI_data([path,fileName{1}],'.img',varargin{2});
        [q_vh,~] = readHSI_data([path,fileName{2}],'.img',varargin{2});
        [i_vv,~] = readHSI_data([path,fileName{3}],'.img',varargin{2});
        [q_vv,~] = readHSI_data([path,fileName{4}],'.img',varargin{2});
    case 3
        [i_vh,~] = readHSI_data([path,fileName{1}],'.img',varargin{2},varargin{3});
        [q_vh,~] = readHSI_data([path,fileName{2}],'.img',varargin{2},varargin{3});
        [i_vv,~] = readHSI_data([path,fileName{3}],'.img',varargin{2},varargin{3});
        [q_vv,~] = readHSI_data([path,fileName{4}],'.img',varargin{2},varargin{3});
end


C2(:,:,3) = i_vh .* i_vv + q_vh .* q_vv;
C2(:,:,4) = q_vh .* i_vv - i_vh .* q_vv;
C2(:,:,1) = i_vh.^2+q_vh.^2;
clear i_vh q_vh
C2(:,:,2) = i_vv.^2+q_vv.^2;
clear i _vv q_vv

end

