function [  ] = writePolSARpro( mat,path )
%This function transform polsar data from matlab form into binary form
%according to polsarpro data format
%   Input
%       - mat           -- polsarpro matlab data
%       - path          -- output data directory
% 
% 
[r,c,d]=size(mat);

text = {'Nrow',...
'2201',...
'---------',...
'Ncol',...
'7456',...
'---------',...
'PolarCase',...
'monostatic',...
'---------',...
'PolarType',...
'pp3'...
};

if exist(path,'file') == 0
    mkdir(path);
end


conf = fopen([path,'\config.txt'],'w');
for i = 1:length(text)
    if i == 2
%         fprintf(fid, '\nNew message in new line\n');
        fprintf(conf,[num2str(c),'\n']);
%         fwrite(conf,num2str(c),'char');
    elseif i == 5
        fprintf(conf,[num2str(r),'\n']);
%         fwrite(conf,num2str{r},'char');
    elseif i == 11 && d == 4
        fprintf(conf,'pp3\n');
%         fwrite(conf,'pp3','char');
    elseif i == 11 && d == 9
        fprintf(conf,'full\n');
%         fwrite(conf,'full','char');
    else
        fprintf(conf,[text{i},'\n']);
%         fwrite(conf,text{i},'char')
    end
end


fclose(conf);

if d==9

C11 = fopen([path,'\C11.bin'],'w');
C22 = fopen([path,'\C22.bin'],'w');
C33 = fopen([path,'\C33.bin'],'w');
C12_real = fopen([path,'\C12_real.bin'],'w');
C12_imag = fopen([path,'\C12_imag.bin'],'w');
C13_real = fopen([path,'\C13_real.bin'],'w');
C13_imag = fopen([path,'\C13_imag.bin'],'w');
C23_real = fopen([path,'\C23_real.bin'],'w');
C23_imag = fopen([path,'\C23_imag.bin'],'w');


fwrite(C11,mat(:,:,1),  'float32');
fwrite(C22,mat(:,:,2),  'float32');
fwrite(C33,mat(:,:,3),  'float32');
fwrite(C12_real,mat(:,:,4),  'float32');
fwrite(C12_imag,mat(:,:,5),  'float32');
fwrite(C13_real,mat(:,:,6),  'float32');
fwrite(C13_imag,mat(:,:,7),  'float32');
fwrite(C23_real,mat(:,:,8),  'float32');
fwrite(C23_imag,mat(:,:,9),  'float32');

fclose(C11);
fclose(C22);
fclose(C33);
fclose(C12_real);
fclose(C13_real);
fclose(C23_real);
fclose(C12_imag);
fclose(C13_imag);
fclose(C23_imag);

end




if d==4
    
    C11 = fopen(cat(2,path,'\C11.bin'),'w');
    C22 = fopen(cat(2,path,'\C22.bin'),'w');
    C12_real = fopen(cat(2,path,'\C12_real.bin'),'w');
    C12_imag = fopen(cat(2,path,'\C12_imag.bin'),'w');


    fwrite(C11,mat(:,:,1),  'float32');
    fwrite(C22,mat(:,:,2),  'float32');
    fwrite(C12_real,mat(:,:,3),  'float32');
    fwrite(C12_imag,mat(:,:,4),  'float32');
    

    fclose(C11);
    fclose(C22);
    fclose(C12_real);
    fclose(C12_imag);
    
end

% im = fPauliImNoShow(mat);
% imwrite(im,[path,'\pseudoColor.tif']);

end

