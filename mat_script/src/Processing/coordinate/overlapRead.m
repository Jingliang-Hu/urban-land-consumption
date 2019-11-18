function [ data ] = overlapRead( varargin )
% This function first read the geo-extent of data given by the variable
% 'masterdir', which is a directory string pointing to a '.hdr' envi file or a
% '.tif' geotiff file. Afterwards, it reads the same area of another data 
% set, whose geoinfo file is given by the variable 'slavedir' and data file
% is given by the variable 'datadir'
%   Detailed explanation goes here
%
%   Call example: 
%       [ data ] = overlapRead( 'masterDir',dir1,'slaveDir',dir2,'dataDir',dir3 );
%       dir1: directory to geoposition file of master image. E.g. *.hdr; *.geotiff
%       dir1 = 'E:\So2Sat\LCZ label\47_training\train\berlin\landsat_8\LC81930232015084LGN00\LC81930232015084LGN00_B2.tif';
%
%       dir2: directory to geoposition file of slave image. E.g. *.hdr; *.geotiff
%       dir2 = 'E:\So2Sat\LCZ label\47_training\train\berlin\sentinel_1\subset_0_of_S1A_IW_SLC__1SDV_20150107T165141_20150107T165205_004068_004E99_A708_Orb_Cal_Deb_TC.data\i_VH.hdr';
%
%       dir3: directory to data file of slave image. E.g. geotiff data files; Polsarpro data files; envi data files
%       dir3 = 'E:\So2Sat\LCZ label\47_training\train\berlin\sentinel_1\subset_0_of_S1A_IW_SLC__1SDV_20150107T165141_20150107T165205_004068_004E99_A708_Orb_Cal_Deb_TC.data\NLM\C2';
% 
%       [ data ] = overlapRead( 'masterDir',dir1,'slaveDir',dir2,'dataDir',dir3 );

% initial output
data = [];

% read input variables
n = 1;
while n < nargin
    switch lower(varargin{n})
        case 'masterdir'
            n = n + 1;
            mpath = varargin{n};
        case 'slavedir'
            n = n + 1;
            spath = varargin{n};
        case 'datadir'
            n = n + 1;
            dpath = varargin{n};
    end
    n = n + 1;
end

% read the extent of master data
dirInfo = strsplit(mpath,'.');
switch lower(dirInfo{end})
    case 'hdr'
        minfo = envihdrread(mpath);
    case 'tif'
        minfo = geotiffinfo(mpath);
    case 'tiff'
        minfo = geotiffinfo(mpath);
end
mgeometa = geoMeta( minfo,'format',dirInfo{end} );

% read the extent of slave data
clear dirInfo
dirInfo = strsplit(spath,'.');
switch lower(dirInfo{end})
    case 'hdr'
        sinfo = envihdrread(spath);
    case 'tif'
        sinfo = geotiffinfo(spath);
    case 'tiff'
        sinfo = geotiffinfo(spath);
end
sgeometa = geoMeta( sinfo,'format',dirInfo{end} );
sgeometa.Projection = strrep(sgeometa.Projection,'_',' ');
% check whether master and slave images are in the same UTM zone or not
if ~strcmpi((mgeometa.Projection),(sgeometa.Projection))
    disp(' ------------------------------------------------------------- ')
    disp(' WARNING: UTM ZONE MIGHT NOT SUIT')
    disp(' ------------------------------------------------------------- ')
    
    NSjudge = ones(1,length(mgeometa.Projection));
    NSjudge(end) = 0;
    if all((mgeometa.Projection == sgeometa.Projection) == NSjudge)
% wikipedia:
% In the northern hemisphere positions are measured northward from zero at 
% he equator. The maximum "northing" value is about 9300000 meters at 
% latitude 84 degrees North, the north end of the UTM zones. In the 
% southern hemisphere northings decrease southward from the equator to 
% about 1100000 meters at 80 degrees South, the south end of the UTM zones.
% The northing at the equator is set at 10000000 meters so no point has a 
% negative northing value.   
        disp('---------------- North heimsphere and South heimsphere Difference ----------------------');
        if mgeometa.YWorldLimits(1)<0
            mgeometa.YWorldLimits = mgeometa.YWorldLimits + 10000000;
        elseif sgeometa.YWorldLimits(1)<0
            sgeometa.YWorldLimits = sgeometa.YWorldLimits + 10000000;
        end
        
        
    else
        disp('---------------- master and slave images are not coordinated in the same UTM zone ----------------------');
        disp(['ground truth data locates in: ',mgeometa.Projection]);
        disp(['polsar data locates in: ',sgeometa.Projection]);
        
        mutm = strsplit(mgeometa.Projection,' ');
        mutm = str2double(mutm{3}(1:2));
        
        stum = strsplit(sgeometa.Projection,' ');
        [lat,lon]=utm2ll([sgeometa.XWorldLimits(1),sgeometa.XWorldLimits(2)],[sgeometa.YWorldLimits(1),sgeometa.YWorldLimits(2)],str2double(stum{3}(1:2)));
        [x,y,f]=ll2utm(lat,lon);

%         [lat,lon]=utm2deg(sgeometa.XWorldLimits,sgeometa.YWorldLimits,[str2double(stum{3}(1:2)),str2double(stum{3}(1:2))]);
%         [x,y,f]=deg2utm(lat,lon);

        if f(1) == mutm
            xshift = x(1) - sgeometa.XWorldLimits(1);
            yshift = y(1) - sgeometa.YWorldLimits(1);
            sgeometa.XWorldLimits = sgeometa.XWorldLimits + xshift;
            sgeometa.YWorldLimits = sgeometa.YWorldLimits + yshift;
        elseif f(2) == mutm
            xshift = x(2) - sgeometa.XWorldLimits(2);
            yshift = y(2) - sgeometa.YWorldLimits(2);
            sgeometa.XWorldLimits = sgeometa.XWorldLimits + xshift;
            sgeometa.YWorldLimits = sgeometa.YWorldLimits + yshift;
        else
            disp('---------------- searching coordinates among UTM zones not success ----------------------');
        end
        sgeometa.Projection = mgeometa.Projection;
        
        
    end
%     return;
end

% find the location of master image in the slave image
cellx = (mgeometa.XWorldLimits - sgeometa.XWorldLimits(1))./sgeometa.CellExtentInWorldX;
cellx = [floor(cellx(1)),ceil(cellx(2))];

celly = (sgeometa.YWorldLimits(2) - mgeometa.YWorldLimits)./sgeometa.CellExtentInWorldY;
celly = [floor(celly(1)),ceil(celly(2))];

if cellx(1) < 0
    disp('------------------- west part of ROI not covered by the data -------------------------');
    cellx(1) = 1;
end
if celly(2) < 0 
    disp('------------------- north part of ROI not covered by the data -------------------------')
    celly(2) = 1;
end
if cellx(2) > sgeometa.RasterSize(2)
    disp('------------------- east part of ROI not covered by the data -------------------------')
    cellx(2) = sgeometa.RasterSize(2);
end
if celly(1) > sgeometa.RasterSize(1)
    disp('------------------- south part of ROI not covered by the data -------------------------')
    celly(1) = sgeometa.RasterSize(1)
end
clear dirInfo
dirInfo = strsplit(dpath,'\');

fileExtension = strsplit(dirInfo{end},'.');
if length(dirInfo{end}) == 2 && strcmp(dirInfo{end} , 'C2')
    % polsarpro data format
    [ polsar,~ ] = readPolSARData( dpath );
    data = polsar(celly(2):celly(1),cellx(1):cellx(2),:);
elseif strcmpi(fileExtension{end},'data') && exist([dpath,'\i_VH.img'],'file')    
    % data is organized as real part and imagenary part of complex values
    % geocoded sentinel 1 in envi data format
    
    rw = {'Row','Range',[celly(2),celly(1)]};
    cl = {'Column','Range',[cellx(1),cellx(2)]};  
    
    fileName = {'\i_VH.img','\q_VH.img','\i_VV.img','\q_VV.img'};      
    i_vh = readHSI_data( [dpath,fileName{1}],'.img',rw,cl );
    q_vh = readHSI_data( [dpath,fileName{2}],'.img',rw,cl );
    i_vv = readHSI_data( [dpath,fileName{3}],'.img',rw,cl );
    q_vv = readHSI_data( [dpath,fileName{4}],'.img',rw,cl );    
    
    data(:,:,1) = i_vh.^2+q_vh.^2;
    data(:,:,2) = i_vv.^2+q_vv.^2;
    data(:,:,3) = i_vh .* i_vv + q_vh .* q_vv;
    data(:,:,4) = q_vh .* i_vv - i_vh .* q_vv;

elseif strcmpi(fileExtension{end},'data') && exist([dpath,'\C11.img'],'file')
    % data is organized as covariace matrix
    % geocoded sentinel 1 in envi data format
    rw = {'Row','Range',[celly(2),celly(1)]};
    cl = {'Column','Range',[cellx(1),cellx(2)]};  
    
    fileName = {'\C11.img','\C22.img','\C12_real.img','\C12_imag.img'};      
    data(:,:,1) = readHSI_data( [dpath,fileName{1}],'.img',rw,cl );
    data(:,:,2) = readHSI_data( [dpath,fileName{2}],'.img',rw,cl );
    data(:,:,3) = readHSI_data( [dpath,fileName{3}],'.img',rw,cl );
    data(:,:,4) = readHSI_data( [dpath,fileName{4}],'.img',rw,cl );   

elseif  strcmpi(fileExtension{end},'tif') || strcmpi(fileExtension{end},'TIF')
    % data is organized as covariance matrix
    % geocoded sentinel 1 in SNAP geotiff format
    % geotiff organization: 
    % 1. C11     
    % 2. C12_real
    % 3. C12_imag
    % 4. C22
    temp = geotiffread(dpath);
    data(:,:,1) = temp(celly(2):celly(1),cellx(1):cellx(2),1);
    data(:,:,2) = temp(celly(2):celly(1),cellx(1):cellx(2),4);
    data(:,:,3) = temp(celly(2):celly(1),cellx(1):cellx(2),2);
    data(:,:,4) = temp(celly(2):celly(1),cellx(1):cellx(2),3);
    
end

% dgeometa = mgeometa;
% dgeometa.RasterSize = [size(data,1),size(data,2)];
% dgeometa.CellExtentInWorldX = sgeometa.CellExtentInWorldX;
% dgeometa.CellExtentInWorldY = sgeometa.CellExtentInWorldY;

end

