function [ C2 ] = readSEN1UnfltBinaryC( varargin )
%UNTITLED3 Summary of this function goes here
%   Detailed explanation goes here


% path = 'E:\So2Sat\data\massive_downloading\0378_index_0033_Adelaide\original_dat\201706\Subset_S1A_IW_SLC__1SDV_20170607T200453_20170607T200519_016932_01C2E2_7E63_Orb_Cal_Deb.data'

path = varargin{1};
fileName = {'\C11.img','\C22.img','\C12_real.img','\C12_imag.img'};


switch nargin
    case 1
        [C2(:,:,1),~] = readHSI_data([path,fileName{1}],'.img');
        [C2(:,:,2),~] = readHSI_data([path,fileName{2}],'.img');
        [C2(:,:,3),~] = readHSI_data([path,fileName{3}],'.img');
        [C2(:,:,4),~] = readHSI_data([path,fileName{4}],'.img');
    case 2
        [C2(:,:,1),~] = readHSI_data([path,fileName{1}],'.img',varargin{2});
        [C2(:,:,2),~] = readHSI_data([path,fileName{2}],'.img',varargin{2});
        [C2(:,:,3),~] = readHSI_data([path,fileName{3}],'.img',varargin{2});
        [C2(:,:,4),~] = readHSI_data([path,fileName{4}],'.img',varargin{2});
    case 3
        [C2(:,:,1),~] = readHSI_data([path,fileName{1}],'.img',varargin{2},varargin{3});
        [C2(:,:,2),~] = readHSI_data([path,fileName{2}],'.img',varargin{2},varargin{3});
        [C2(:,:,3),~] = readHSI_data([path,fileName{3}],'.img',varargin{2},varargin{3});
        [C2(:,:,4),~] = readHSI_data([path,fileName{4}],'.img',varargin{2},varargin{3});
end



end

