%% choose a city
city = 'munich_cLCZ_perc/';
% city = 'nyc_cLCZ/';
% city = 'bom_cLCZ/';


path = ['/data/hu/SDG/',city];

%% sen1
sen1 = [];
load([path,'sen1/sen1_xv_trp_10.mat'], 'oa')
sen1_10 = oa;
sen1 = [sen1,[mean(oa);std(oa)]];
load([path,'sen1/sen1_xv_trp_50.mat'], 'oa')
sen1_50 = oa;
sen1 = [sen1,[mean(oa);std(oa)]];
load([path,'sen1/sen1_xv_trp_90.mat'], 'oa')
sen1_90 = oa;
sen1 = [sen1,[mean(oa);std(oa)]];

%% sen2
sen2 = [];
load([path,'sen2/sen2_xv_trp_10.mat'], 'oa')
sen2_10 = oa;
sen2 = [sen2,[mean(oa);std(oa)]];
load([path,'sen2/sen2_xv_trp_50.mat'], 'oa')
sen2_50 = oa;
sen2 = [sen2,[mean(oa);std(oa)]];
load([path,'sen2/sen2_xv_trp_90.mat'], 'oa')
sen2_90 = oa;
sen2 = [sen2,[mean(oa);std(oa)]];


%% con
con = [];
load([path,'con/con_xv_trp_10.mat'], 'oa')
con_10 = oa;
con = [con,[mean(oa);std(oa)]];
load([path,'con/con_xv_trp_50.mat'], 'oa')
con_50 = oa;
con = [con,[mean(oa);std(oa)]];
load([path,'con/con_xv_trp_90.mat'], 'oa')
con_90 = oa;
con = [con,[mean(oa);std(oa)]];


%% mima
mima = [];

% 10%
oa = [];
load([path,'mima/mima_2t_en_pc_sc_p_trp_10_xv_1.mat'], 'oae')
oa = [oa,oae];
load([path,'mima/mima_2t_en_pc_sc_p_trp_10_xv_2.mat'], 'oae')
oa = [oa,oae];
load([path,'mima/mima_2t_en_pc_sc_p_trp_10_xv_3.mat'], 'oae')
oa = [oa,oae];
load([path,'mima/mima_2t_en_pc_sc_p_trp_10_xv_4.mat'], 'oae')
oa = [oa,oae];
load([path,'mima/mima_2t_en_pc_sc_p_trp_10_xv_5.mat'], 'oae')
oa = [oa,oae];
load([path,'mima/mima_2t_en_pc_sc_p_trp_10_xv_6.mat'], 'oae')
oa = [oa,oae];
load([path,'mima/mima_2t_en_pc_sc_p_trp_10_xv_7.mat'], 'oae')
oa = [oa,oae];
load([path,'mima/mima_2t_en_pc_sc_p_trp_10_xv_8.mat'], 'oae')
oa = [oa,oae];
load([path,'mima/mima_2t_en_pc_sc_p_trp_10_xv_9.mat'], 'oae')
oa = [oa,oae];
load([path,'mima/mima_2t_en_pc_sc_p_trp_10_xv_10.mat'], 'oae')
oa = [oa,oae];
mima_10 = oa;
mima = [mima,[mean(oa);std(oa)]];

% 50%
oa = [];
load([path,'mima/mima_2t_en_pc_sc_p_trp_50_xv_1.mat'], 'oae')
oa = [oa,oae];
load([path,'mima/mima_2t_en_pc_sc_p_trp_50_xv_2.mat'], 'oae')
oa = [oa,oae];
load([path,'mima/mima_2t_en_pc_sc_p_trp_50_xv_3.mat'], 'oae')
oa = [oa,oae];
load([path,'mima/mima_2t_en_pc_sc_p_trp_50_xv_4.mat'], 'oae')
oa = [oa,oae];
load([path,'mima/mima_2t_en_pc_sc_p_trp_50_xv_5.mat'], 'oae')
oa = [oa,oae];
load([path,'mima/mima_2t_en_pc_sc_p_trp_50_xv_6.mat'], 'oae')
oa = [oa,oae];
load([path,'mima/mima_2t_en_pc_sc_p_trp_50_xv_7.mat'], 'oae')
oa = [oa,oae];
load([path,'mima/mima_2t_en_pc_sc_p_trp_50_xv_8.mat'], 'oae')
oa = [oa,oae];
load([path,'mima/mima_2t_en_pc_sc_p_trp_50_xv_9.mat'], 'oae')
oa = [oa,oae];
load([path,'mima/mima_2t_en_pc_sc_p_trp_50_xv_10.mat'], 'oae')
oa = [oa,oae];
mima_50 = oa;
mima = [mima,[mean(oa);std(oa)]];

% 90%
oa = [];
load([path,'mima/mima_2t_en_pc_sc_p_trp_90_xv_1.mat'], 'oae')
oa = [oa,oae];
load([path,'mima/mima_2t_en_pc_sc_p_trp_90_xv_2.mat'], 'oae')
oa = [oa,oae];
load([path,'mima/mima_2t_en_pc_sc_p_trp_90_xv_3.mat'], 'oae')
oa = [oa,oae];
load([path,'mima/mima_2t_en_pc_sc_p_trp_90_xv_4.mat'], 'oae')
oa = [oa,oae];
load([path,'mima/mima_2t_en_pc_sc_p_trp_90_xv_5.mat'], 'oae')
oa = [oa,oae];
load([path,'mima/mima_2t_en_pc_sc_p_trp_90_xv_6.mat'], 'oae')
oa = [oa,oae];
load([path,'mima/mima_2t_en_pc_sc_p_trp_90_xv_7.mat'], 'oae')
oa = [oa,oae];
load([path,'mima/mima_2t_en_pc_sc_p_trp_90_xv_8.mat'], 'oae')
oa = [oa,oae];
load([path,'mima/mima_2t_en_pc_sc_p_trp_90_xv_9.mat'], 'oae')
oa = [oa,oae];
load([path,'mima/mima_2t_en_pc_sc_p_trp_90_xv_10.mat'], 'oae')
oa = [oa,oae];
mima_90 = oa;
mima = [mima,[mean(oa);std(oa)]];


%% visualization
sen1 = round(sen1*1e4)./1e2;
sen2 = round(sen2*1e4)./1e2;
con  = round(con *1e4)./1e2;
mima = round(mima*1e4)./1e2;

% overall summary
x = [10,50,90];
figure(10),hold on;
% s1 = errorbar(x,sen1(1,:),sen1(2,:),'m');
s2 = errorbar(x,sen2(1,:),sen2(2,:),'c');
cn = errorbar(x,con(1,:) ,con(2,:) ,'k');
mi = errorbar(x,mima(1,:),mima(2,:),'b');
grid on;
legendName = {'Sentinel-1','Sentinel-2','Concatenation','MIMA'};
legend(legendName{:})

% 10%
x = 1:10;
figure(11),hold on;
s1 = plot(x,sen1_10,'m');
s2 = plot(x,sen2_10,'c');
cn = plot(x,con_10 ,'k');
mi = plot(x,mima_10,'b');
grid on;
legendName = {'Sentinel-1','Sentinel-2','Concatenation','MIMA'};
legend(legendName{:})

% 50%
x = 1:10;
figure(12),hold on;
s1 = plot(x,sen1_50,'m');
s2 = plot(x,sen2_50,'c');
cn = plot(x,con_50 ,'k');
mi = plot(x,mima_50,'b');
grid on;
legendName = {'Sentinel-1','Sentinel-2','Concatenation','MIMA'};
legend(legendName{:})

% 90%
x = 1:10;
figure(13),hold on;
s1 = plot(x,sen1_90,'m');
s2 = plot(x,sen2_90,'c');
cn = plot(x,con_90 ,'k');
mi = plot(x,mima_90,'b');
grid on;
legendName = {'Sentinel-1','Sentinel-2','Concatenation','MIMA'};
legend(legendName{:})



