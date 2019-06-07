%% in order to run the test, the postprocessing of sentinel-1 and sentinel-2 data should not be involved
% comment line 95: [~] = se1Processing(matObj) in  [ se1Feat ] = sen1FeatExtractMem( path, datTmpPath )
% comment line 110: [~] = se2Processing(matObj); in [ se2Feat ] = sen2FeatExtractMem( path, datTmpPath )



%% sentinel-1 test

path = '/naslx/projects/pr84ya/ga39lev3/SDG/mat_script/data/LCZ42_21671_Tokyo/SE1/mosaic.tif';

tic
[ se1Feat ] = sen1FeatExtract( path );
toc

tic
[ se1FeatMem ] = sen1FeatExtractMem( path );
toc

err = sum(sum(sum(abs((se1FeatMem(:,:,:))-(se1Feat(:,:,:))))))

bnd = 0;
for i = 1:36
    a = sum(sum(abs((se1FeatMem(:,:,i))-(se1Feat(:,:,i)))));
    if a >1e-5
        bnd = [bnd,i];
    end
end
bnd



%% sentinel-2 test

path = '/naslx/projects/pr84ya/ga39lev3/SDG/mat_script/data/LCZ42_21671_Tokyo/SE2/21671_summer.tif';

tic
[ se2Feat ] = sen2FeatExtract( path );
toc

tic
[ se2FeatMem ] = sen2FeatExtractMem( path );
toc

err = sum(sum(sum(abs((se2FeatMem)-(single(se2Feat))))))

bnd = zeros(size(se2Feat,3),1);
bndErr = zeros(size(se2Feat,3),1);
for i = 1:size(se2Feat,3)
    bndErr(i) =sum(sum(abs((se2FeatMem(:,:,i))-(se2Feat(:,:,i)))));
    if bndErr(i) >1e-5
        bnd(i) = i;
    end
end
bnd
bndErr
