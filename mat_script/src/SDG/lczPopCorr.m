function [spatilCorrelation] = lczPopCorr(lczTif,popTif)



% popTif = '/naslx/projects/pr84ya/ga39lev3/SDG/mat_script/data/LCZ42_21671_Tokyo/LCZ42_21671_Tokyo_POP.tif';
% lczTif = '/naslx/projects/pr84ya/ga39lev3/SDG/mat_script/data/LCZ42_21671_Tokyo/LCZ42_21671_Tokyo_CLCZ.tif';
disp('load lcz data ...')
lcz = single(geotiffread(lczTif));
lcz(lcz==1) = 4;
lcz(lcz==6) = 3;
lcz(lcz==7) = 4;
lcz(lcz==8) = 2;
lcz(lcz==107) = 0;
lcz(lcz>10) = 1;

disp('load population data ...')
pop = single(geotiffread(popTif));
popTmp = imresize(pop,size(lcz),'nearest');
pop = popTmp*sum(pop(:))/sum(popTmp(:)); clear popTmp;

noDataValue = -10;

% set up neighborhood
disp('Set up the neighborhood kernel ...')
res = 10;
neighborDist = 2000; % meter
neighborPix  = neighborDist/res;
neighborKernel = strel('sphere',neighborPix);
neighborKernel = neighborKernel.Neighborhood(:,:,neighborPix+1);

lczPad = padarray(lcz,[neighborPix,neighborPix],'symmetric');
popPad = padarray(pop,[neighborPix,neighborPix],'symmetric');
neighborKernel = [  neighborKernel,                                                     zeros(size(neighborKernel,1),size(lczPad,2)-size(neighborKernel,2));...
                    zeros(size(lczPad,1)-size(neighborKernel,1),size(neighborKernel,2)),        zeros(size(lczPad,1)-size(neighborKernel,1),size(lczPad,2)-size(neighborKernel,2))]==1;


% initial output
disp('parallel computing ... ')
spatilCorrelation = zeros(size(pop),'single');
% num_core = feature('numcores');
num_core = 40;
a = parpool(num_core);
a.IdleTimeout = 200;
disp([num2str(num_core),' cores are activated and work in parallel ...'])

for cv_row = 1:size(spatilCorrelation,1)
    parfor cv_col = 1:size(spatilCorrelation,2)
        idx = circshift(neighborKernel,[cv_row,cv_col]);
        tmp = corrcoef(lczPad(idx(:)),popPad(idx(:)));
        spatilCorrelation(cv_row,cv_col) = tmp(1,2);
    end
    if mod(cv_row,ceil(size(spatilCorrelation,1)/10)) == 0
        disp([num2str(cv_row/size(spatilCorrelation,1)*100),' % is done ...']);
    end
end
delete(gcp('nocreate'));

disp('parallel computing done')
spatilCorrelation(lcz(:)==0) = noDataValue;

end
