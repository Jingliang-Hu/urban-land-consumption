%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%                                                                     %%%
%%% File:        image_write.m                                          %%%
%%%                                                                     %%%
%%% Author:      Dipl.-math.techn. Claas Grohnfeldt (since 09/2015)     %%%
%%%                                                                     %%%
%%% Contact:     Claas Grohnfeldt                                       %%%
%%%              German Aerospace Center (DLR)                          %%%
%%%              Institute:  Remote Sensing Technology Institute (MF)   %%%
%%%              Department: SAR Signal Processing                      %%%
%%%              Location:   Oberpfaffenhofen, Germany                  %%%
%%%              Email:      Claas.Grohnfeldt@dlr.de                    %%%
%%%                                                                     %%%
%%% Version:     1.0 (since 01/09/2015)                                 %%%
%%%                                                                     %%%
%%% Last Modification: October 13, 2015                                 %%%
%%%                                                                     %%%
%%% Security Classification: Confidential                               %%%
%%%                                                                     %%%
%%% Copyright:   [2015] - [2015] DLR. All Rights Reserved.              %%%
%%%                                                                     %%%
%%%              Notice: All information contained herein is, and       %%%
%%%              remains the property of DLR and its suppliers, if any. %%%
%%%              The intellectual and technical concepts contained      %%%
%%%              herein are proprietary to DLR and its suppliers and    %%%
%%%              may be covered by German and Foreign Patents, patents  %%%
%%%              in process, and are protected by trade secret or       %%%
%%%              copyright law. Dissemination of this information or    %%%
%%%              reproduction of this material is strictly forbidden    %%%
%%%              unless prior written permission is obtained from DLR.  %%%
%%%                                                                     %%%
%%% Description: tbd                                                    %%%
%%%                                                                     %%%
%%%                                                                     %%%
%%% input:  - Im           input image                                  %%%
%%%         - filename     file name of input image                     %%%
%%%         - format       data format of input image                   %%%
%%%         - filetype_out desired file type of output image            %%%
%%%         - varargin     more optional input parameters (see below)   %%%
%%%                                                                     %%%
%%% output: - Im_corrupted:  image corrupted with white Gaussian noise  %%%
%%%                                                                     %%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function [] = image_write(Im, filename, format, filetype_out, varargin)

eval(['Im = ', format,'(Im);'])


if(filetype_out==1) % write output to ENVI file
    Im_info = enviinfo(Im);        
    if ~isempty(varargin)        
        Im_ref_info  = varargin{1};
        fDS          = varargin{2};
        copyInfoType = varargin{3};
        if strcmp(copyInfoType,'spectral') || strcmp(copyInfoType,'spatial_spectral')
            if isfield(Im_ref_info,'wavelength')
                Im_info.wavelength = Im_ref_info.wavelength;
            end
            if isfield(Im_ref_info,'wavelength_units')
                Im_info.wavelength_units = Im_ref_info.wavelength_units;
            end
            if isfield(Im_ref_info,'band_names')
                Im_info.band_names = Im_ref_info.band_names;
            end        
            if isfield(Im_ref_info,'z_plot_titles')
                Im_info.z_plot_titles = Im_ref_info.z_plot_titles;
            end
        end
        if strcmp(copyInfoType,'spatial') || strcmp(copyInfoType,'spatial_spectral')                
            if isfield(Im_ref_info,'coordinate_system_string')
                Im_info.coordinate_system_string = Im_ref_info.coordinate_system_string;
            end
            if isfield(Im_ref_info,'map_info')
                Im_info.map_info = Im_ref_info.map_info;

                Im_info.map_info = deblank(Im_info.map_info);
                Im_info.map_info = Im_info.map_info(2:end-1); % remove parentheses '{' and '}'
                C = strsplit(Im_info.map_info,',');            
                pixel_size_x = str2double(C{6});
                C{6} = num2str(fDS*pixel_size_x);
                pixel_size_y = str2double(C{7});
                C{7} = num2str(fDS*pixel_size_y);
                Im_info.map_info = '{';
                for i=1:length(C)
                    Im_info.map_info = [Im_info.map_info,',',C{i}];
                end
                Im_info.map_info = [Im_info.map_info,'}'];
            end
            if isfield(Im_ref_info,'y_start') % may have to be devided by fDS!
                Im_info.y_start = Im_ref_info.y_start;
            end
            if isfield(Im_ref_info,'x_start') % may have to be devided by fDS!
                Im_info.x_start = Im_ref_info.x_start;
            end
        end
    end
    
    enviwrite(Im,Im_info, filename);
% elseif(filetype_out==2) % write output to tiff file
%     imwrite(filename,'tiff','Compression','none');
else
   error('Unknown file format. Please chooese filetype_out to be either 1 (ENVI) or 2 (Tiff)')
end





































% 
% 
% 
% if(filetype_out==1) % write output to ENVI file
%     if param.HSHR_orig_avlbl
%         if(~strcmp(paths.fname_HSHR_orig_hdr,''))
%             [HSHR_orig,HSHR_orig_info]=enviread(paths.compl_fname_HSHR_orig,paths.compl_fname_HSHR_orig_hdr);
%         else
%             try % try geotiff
%                 fprintf('try to use geotiffwrite instead of imwrite..\n');
%                 [HSHR_orig, R] = geotiffread(paths.compl_fname_HSHR_orig);
%                 mygeotiffinfo = geotiffinfo(paths.compl_fname_HSHR_orig);
%             catch ME
%                 %ME
%                 fprintf('geotiffwrite returns an error. So, use imread instead\n');
%                 HSHR_orig = imread(paths.compl_fname_HSHR_orig);
%             end
%             classHSHR_orig = class(HSHR_orig);            
%             HSHR_orig_info = enviinfo(classHSHR_orig);
%             HSHR_orig = double(HSHR_orig);
%         end    
%         %D=rand(2,3,4)+j*rand(2,3,4);
%         %info=enviinfo(D);
%         enviwrite(HSHR_rec,HSHR_orig_info,paths.compl_fname_HSHR_rec);
%     else
%         HSHR_orig_info=enviinfo(HSHR_orig);
%         enviwrite(HSHR_rec,HSHR_orig_info,paths.compl_fname_HSHR_rec);
%     end
% elseif(filetype_out==2) % write output to tiff file
%     
%         if(~strcmp(paths.fname_HSHR_orig_hdr,''))
%             [HSHR_orig,HSHR_orig_info]=enviread(paths.compl_fname_HSHR_orig,paths.compl_fname_HSHR_orig_hdr);
%         else
%             try % try geotiff
%                 fprintf('try to use geotiffwrite instead of imwrite..\n');
%                 [HSHR_orig, R] = geotiffread(paths.compl_fname_HSHR_orig);
%                 mygeotiffinfo = geotiffinfo(paths.compl_fname_HSHR_orig);
%             catch ME
%                 %ME
%                 fprintf('geotiffwrite returns an error. So, use imread instead\n');
%                 HSHR_orig = imread(paths.compl_fname_HSHR_orig);
%             end
%             classHSHR_orig = class(HSHR_orig);            
%             HSHR_orig_info = enviinfo(classHSHR_orig);
%             HSHR_orig = double(HSHR_orig);
%         end    
% %     try % try geotiff
% %         fprintf('try to use geotiffwrite instead of imwrite..\n');
% %         [HSHR_orig, R] = geotiffread(paths.compl_fname_HSHR_orig);
% %         mygeotiffinfo = geotiffinfo(paths.compl_fname_HSHR_orig);
% %     catch ME
% %         %ME
% %         fprintf('geotiffwrite returns an error. So, use imread instead\n');
% %         HSHR_orig = imread(paths.compl_fname_HSHR_orig);
% %     end
%     classHSHR_orig = class(HSHR_orig);
%     HSHR_orig = double(HSHR_orig);
%     
%     eval(['HSHR_rec = ',classHSLR,'(HSHR_rec);'])
%     try 
%         fprintf('try to use geotiffwrite instead of imwrite..\n');
%         if param.HSHR_orig_avlbl
%             geoRef_fname = [paths.dir_HSHR_orig,'/',paths.fname_HSHR_orig];
%         else
%             geoRef_fname = [paths.dir_in,'/',paths.MSHR];
%         end
%         [A, R] = geotiffread(geoRef_fname);
%         myinfo = geotiffinfo(geoRef_fname);
%         geotiffwrite([paths.dir_out,'/',paths.compl_fname_HSHR_rec],HSHR_rec,R,'GeoKeyDirectoryTag', myinfo.GeoTIFFTags.GeoKeyDirectoryTag);
%         fprintf('geotiff was successfull!\n');
%     catch ME
%         ME
%         fprintf('geotiff gives an error. So, use imread instead\n');
%         imwrite(HSHR_rec,[paths.dir_out,'/',paths.compl_fname_HSHR_rec],'tiff','Compression','none');
%     end
% end
% 
