function [spatilCorrelation] = lczPopCorr(lczTif,popTif)

% popTif = '/naslx/projects/pr84ya/ga39lev3/SDG/mat_script/data/LCZ42_21671_Tokyo/LCZ42_21671_Tokyo_POP.tif';
% lczTif = '/naslx/projects/pr84ya/ga39lev3/SDG/mat_script/data/LCZ42_21671_Tokyo/LCZ42_21671_Tokyo_CLCZ.tif';

lcz = single(geotiffread(lczTif));
pop = single(geotiffread(popTif));
noDataValue = -10;

% set up neighborhood
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
spatilCorrelation = zeros(size(pop),'single');
a = parpool(28);
a.IdleTimeout = 200;
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


spatilCorrelation(lcz(:)==107) = noDataValue;                

end