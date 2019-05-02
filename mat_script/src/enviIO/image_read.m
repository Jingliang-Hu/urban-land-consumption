%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%                                                                     %%%
%%% File:        image_read.m                                           %%%
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
%%% Description: reads multiband images                                 %%%
%%%                                                                     %%%
%%%                                                                     %%%
%%% input:  - filename_data  file name of the input image               %%%
%%%         - filename_hdr   file name of input image                   %%%
%%%                                                                     %%%
%%% output: - Im                                                        %%%
%%%         - class_Im                                                  %%%
%%%         - Im_info                                                   %%%
%%%                                                                     %%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function [Im,class_Im,Im_info] = image_read(filename_data, filename_hdr)

% try ENVI
% try
    [Im,Im_info]=enviread(filename_data, filename_hdr);
    switch Im_info.data_type
        case 1 %  = Byte: 8-bit unsigned integer
            class_Im = 'uint8';
        case 2 %  = Integer: 16-bit signed integer
            class_Im = 'int16';
        case 3 %  = Long: 32-bit signed integer
            class_Im = 'int32';
        case 4 %  = Floating-point: 32-bit single-precision
            class_Im = 'single'; % I made it up! this has to be added when needed
        case 5 %  = Double-precision: 64-bit double-precision floating-point
            class_Im = 'double'; % I made it up! this has to be added when needed
        case 6 %  = Complex: Real-imaginary pair of single-precision floating-point
            error('Image data type is 6==complex. Matlab does not support this format!')
        case 9 %  = Double-precision complex: Real-imaginary pair of double precision floating-point
            error('Image data type is 9==double_precision_complex. Matlab does not support this format!')
        case 12 % = Unsigned integer: 16-bit
            class_Im = 'uint16';
        case 13 % = Unsigned long integer: 32-bit
            class_Im = 'uint32'; % I made it up! this has to be added when needed
        case 14 % = 64-bit long integer (signed)
            class_Im = 'int64'; % I made it up! this has to be added when needed
        case 15 % = 64-bit unsigned long integer (unsigned)
            class_Im = 'uint64';
    end
    Im = double(Im);
    return
% end
% else: try geotiff  %  <= not supported any longer
% try 
%     [Im, R] = geotiffread(filename_data);
%     mygeotiffinfo = geotiffinfo(filename_data);
%     class_Im = class(Im);
%     Im = double(Im);
%     return
% end
% 
% % else: read any other image file format via imread
% Im = imread(filename_data);
% class_Im = class(Im);
% Im = double(Im);

% 
% [~,~,ext] = fileparts(filename_data);
% if(strcmp(ext,'tiff') || strcmp(ext,'tif'))
%     try % try geotiff
%         fprintf('try to use geotiffwrite instead of imwrite..\n');
%         [Im, R] = geotiffread(filename_data);
%         mygeotiffinfo = geotiffinfo(filename_data);
%     catch ME
%         %ME
%         fprintf('geotiffwrite returns an error. So, use imread instead\n');
%         Im = imread(filename_data);
%     end
%     class_Im = class(Im);
%     Im = double(Im);
% else % assume the format is ENVI
%     [Im,Im_info]=enviread(filename_data, filename_hdr);    
%     switch Im_info.data_type
%         case 1 %  = Byte: 8-bit unsigned integer
%             class_Im = 'uint8';
%         case 2 %  = Integer: 16-bit signed integer
%             class_Im = 'int16';
%         case 3 %  = Long: 32-bit signed integer
%             class_Im = 'int32';
%         case 4 %  = Floating-point: 32-bit single-precision
%             class_Im = 'single'; % I made it up! this has to be added when needed
%         case 5 %  = Double-precision: 64-bit double-precision floating-point
%             class_Im = 'double'; % I made it up! this has to be added when needed
%         case 6 %  = Complex: Real-imaginary pair of single-precision floating-point
%             error('Image data type is 6==complex. Matlab does not support this format!')
%         case 9 %  = Double-precision complex: Real-imaginary pair of double precision floating-point
%             error('Image data type is 9==double_precision_complex. Matlab does not support this format!')
%         case 12 % = Unsigned integer: 16-bit
%             class_Im = 'uint16';
%         case 13 % = Unsigned long integer: 32-bit
%             class_Im = 'uint32'; % I made it up! this has to be added when needed
%         case 14 % = 64-bit long integer (signed)
%             class_Im = 'int64'; % I made it up! this has to be added when needed
%         case 15 % = 64-bit unsigned long integer (unsigned)
%             class_Im = 'uint64';
%     end
% end


