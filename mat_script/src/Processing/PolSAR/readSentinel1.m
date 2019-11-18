
clear
%%% -------------------- local climate zone sentinel 1 ----------------------
%%% Berlin
% path = 'E:\So2Sat\LCZ label\47_training\train\berlin\sentinel_1\subset_0_of_S1A_IW_SLC__1SDV_20150107T165141_20150107T165205_004068_004E99_A708_Orb_Cal_Deb_TC.data';
%%% Hong Kong
% path = 'E:\So2Sat\LCZ label\47_training\train\hong_kong\sentinel_1\subset_0_of_hongkong.data';
%%% Paris
% path = 'E:\So2Sat\LCZ label\47_training\train\paris\sentinel_1\subset_0_of_temp.data';
%%% Rome
% path = 'E:\So2Sat\LCZ label\47_training\train\rome\sentinel_1\subset_1_of_S1A_IW_SLC__1SDV_20150604T051121_20150604T051149_006219_0081E6_B5A6_Orb_Cal_Deb_TC.data';
%%% Sao Paolo
% path = 'E:\So2Sat\LCZ label\47_training\train\sao_paulo\sentinel_1\subset_0_of_S1A_IW_SLC__1SDV_20151227T083040_20151227T083108_009225_00D4CF_C068_Orb_Cal_Deb_TC.data';

%%% Amsterdam
% path = 'E:\So2Sat\LCZ label\47_dataset\test\amsterdam\sentinel_1\subset_0_of_S1A_IW_SLC__1SDV_20151214T054931_20151214T055001_009034_00CF62_906B_Orb_Cal_Deb_TC.data';
%%% Chicago
% path = 'E:\So2Sat\LCZ label\47_dataset\test\chicago\sentinel_1\subset_0_of_S1A_EW_SLC__1SDV_20150926T234024_20150926T234130_007893_00B039_016F_Orb_Cal_Deb_TC.data';
%%% Madrid
% path = 'E:\So2Sat\LCZ label\47_dataset\test\madrid\sentinel_1\subset_0_of_S1A_IW_SLC__1SDV_20151117T181050_20151117T181117_008648_00C49E_26DE_Orb_Cal_Deb_TC.data';
%%% Xi'an
path = 'E:\So2Sat\LCZ label\47_dataset\test\xi_an\sentinel_1\subset_0_of_S1A_IW_SLC__1SDV_20150220T224638_20150220T224705_004713_005D3A_4981_Orb_Cal_Deb_TC.data';




fileName = {'\i_VH.img','\q_VH.img','\i_VV.img','\q_VV.img'};



% rw = {'Row','Range',[1300,11300]};
% cl = {'Column','Range',[1,20000]};
% 
% i_vh = readHSI_data([path,fileName{1}],rw,cl);
% q_vh = readHSI_data([path,fileName{2}],rw,cl);
% 
% i_vv = readHSI_data([path,fileName{3}],rw,cl);
% q_vv = readHSI_data([path,fileName{4}],rw,cl);



% cl = {'Column','Range',[2000,9500]};
[i_vh,r] = readHSI_data([path,fileName{1}],'.img');
[q_vh,r] = readHSI_data([path,fileName{2}],'.img');

[i_vv,r] = readHSI_data([path,fileName{3}],'.img');
[q_vv,r] = readHSI_data([path,fileName{4}],'.img');


C2(:,:,1) = i_vh.^2+q_vh.^2;

C2(:,:,2) = i_vv.^2+q_vv.^2;

C2(:,:,3) = i_vh .* i_vv + q_vh .* q_vv;

C2(:,:,4) = q_vh .* i_vv - i_vh .* q_vv;


figure,fPauliImShow1(C2,sum(C2,3)~=0);


%%
path = 'D:\Original_test_data\TSX\Mumbai\TSX1_SAR_SSC_SM_Q_DRA_20150311T010711_20150311T010719_Cal_TC.data';

fileName = {'\i_HH.img','\q_HH.img','\i_HV.img','\q_HV.img','\i_VH.img','\q_VH.img','\i_VV.img','\q_VV.img'};



% rw = {'Row','Range',[1300,11300]};
% cl = {'Column','Range',[4300,16000]};
% 
% i_vh = readHSI_data([path,fileName{1}],rw,cl);
% q_vh = readHSI_data([path,fileName{2}],rw,cl);
% 
% i_vv = readHSI_data([path,fileName{3}],rw,cl);
% q_vv = readHSI_data([path,fileName{4}],rw,cl);



%sinclair to  covariance
%   S(:,:,1): real(HH) + imag(HH)*1i
%   S(:,:,2): real(HV) + imag(HV)*1i
%   S(:,:,3): real(VH) + imag(VH)*1i
%   S(:,:,4): real(VV) + imag(VV)*1i

% real ---- i
% imag ---- q


cl = {'Column','Range',[2000,9500]};
[i_hh,r] = readHSI_data([path,fileName{1}]);
[q_hh,r] = readHSI_data([path,fileName{2}]);

[i_hv,r] = readHSI_data([path,fileName{3}]);
[q_hv,r] = readHSI_data([path,fileName{4}]);

[i_vh,r] = readHSI_data([path,fileName{5}]);
[q_vh,r] = readHSI_data([path,fileName{6}]);

[i_vv,r] = readHSI_data([path,fileName{7}]);
[q_vv,r] = readHSI_data([path,fileName{8}]);


S(:,:,1) = i_hh + q_hh.*1i; clear i_hh q_hh
S(:,:,2) = i_hv + q_hv.*1i; clear i_hv q_hv
S(:,:,3) = i_vh + q_vh.*1i; clear i_vh q_vh
S(:,:,4) = i_vv + q_vv.*1i; clear i_vv q_vv




figure,fPauliImShow1(C2,sum(C2,3)~=0);


%%
path='E:\So2Sat\data\amsterdam\ocean_preserve\S1A_IW_SLC__1SDV_20161201T055804_20161201T055831_014182_016E96_18BA_Orb_Cal_Deb_Spk_TC_SUB.data';
fileName = {'\C11.img','\C12_real.img','\C12_imag.img','\C22.img'};


[C2(:,:,1),r] = readHSI_data([path,fileName{1}],'.img');
[C2(:,:,3),r] = readHSI_data([path,fileName{2}],'.img');

[C2(:,:,4),r] = readHSI_data([path,fileName{3}],'.img');
[C2(:,:,2),r] = readHSI_data([path,fileName{4}],'.img');

figure,fPauliImShow1(C2,sum(C2,3)~=0);


