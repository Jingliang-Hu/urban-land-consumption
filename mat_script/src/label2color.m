function classif=label2color(label, data_name)

[w, h]=size(label);

im=zeros(w,h,3);

switch lower(data_name)
    
    case 'uni'
        map=[192 192 192;0 255 0;0 255 255;0 128 0; 255 0 255;165 82 41;128 0 128;255 0 0;255 255 0];
        for i=1:w
            for j=1:h
                switch(label(i,j))
                    case(1)
                        im(i,j,:)=uint8(map(1,:));
                    case(2)
                        im(i,j,:)=uint8(map(2,:));
                    case(3)
                        im(i,j,:)=uint8(map(3,:));
                    case(4)
                        im(i,j,:)=uint8(map(4,:));
                    case(5)
                        im(i,j,:)=uint8(map(5,:));
                    case(6)
                        im(i,j,:)=uint8(map(6,:));
                    case(7)
                        im(i,j,:)=uint8(map(7,:));
                    case(8)
                        im(i,j,:)=uint8(map(8,:));
                    case(9)
                        im(i,j,:)=uint8(map(9,:));
                end
            end
        end
        
    case 'center'
        map=[0 0 255;0 128 0;0 255 0;255 0 0;142 71 2;192 192 192;0 255 255;246 110 0; 255 255 0];
        for i=1:w
            for j=1:h
                switch(label(i,j))
                    case(1)
                        im(i,j,:)=uint8(map(1,:));
                    case(2)
                        im(i,j,:)=uint8(map(2,:));
                    case(3)
                        im(i,j,:)=uint8(map(3,:));
                    case(4)
                        im(i,j,:)=uint8(map(4,:));
                    case(5)
                        im(i,j,:)=uint8(map(5,:));
                    case(6)
                        im(i,j,:)=uint8(map(6,:));
                    case(7)
                        im(i,j,:)=uint8(map(7,:));
                    case(8)
                        im(i,j,:)=uint8(map(8,:));
                    case(9)
                        im(i,j,:)=uint8(map(9,:));
                end
            end
        end
        
    case 'india'
%         map=[0 0 255;255 100 0;0 255 134;150 70 150; 100 150 255;60 90 114;255 255 125;255 0 255;100 0 255;1 170 255;0 255 0;175 175 82;100 190 56;140 67 46;115 255 172;255 255 0];
            map=[140 67 46;0 0 255;255 100 0;0 255 123;164 75 155;101 174 255;118 254 172; 60 91 112;255,255,0;255 255 125;255 0 255;100 0 255;0 172 254;0 255 0;171 175 80;101 193 60];
        for i=1:w
            for j=1:h
                switch(label(i,j))
                    case(1)
                        im(i,j,:)=uint8(map(1,:));
                    case(2)
                        im(i,j,:)=uint8(map(2,:));
                    case(3)
                        im(i,j,:)=uint8(map(3,:));
                    case(4)
                        im(i,j,:)=uint8(map(4,:));
                    case(5)
                        im(i,j,:)=uint8(map(5,:));
                    case(6)
                        im(i,j,:)=uint8(map(6,:));
                    case(7)
                        im(i,j,:)=uint8(map(7,:));
                    case(8)
                        im(i,j,:)=uint8(map(8,:));
                    case(9)
                        im(i,j,:)=uint8(map(9,:));
                    case(10)
                        im(i,j,:)=uint8(map(10,:));
                    case(11)
                        im(i,j,:)=uint8(map(11,:));
                    case(12)
                        im(i,j,:)=uint8(map(12,:));
                    case(13)
                        im(i,j,:)=uint8(map(13,:));
                    case(14)
                        im(i,j,:)=uint8(map(14,:));   
                    case(15)
                        im(i,j,:)=uint8(map(15,:));   
                    case(16)
                        im(i,j,:)=uint8(map(16,:));   
                end
            end
        end
    case 'dc'
        map=[204 102 102;153 51 0;204 153 0;0 255 0; 0 102 0;0 51 255;153 153 153];
        for i=1:w
            for j=1:h
                switch(label(i,j))
                    case(1)
                        im(i,j,:)=uint8(map(1,:));
                    case(2)
                        im(i,j,:)=uint8(map(2,:));
                    case(3)
                        im(i,j,:)=uint8(map(3,:));
                    case(4)
                        im(i,j,:)=uint8(map(4,:));
                    case(5)
                        im(i,j,:)=uint8(map(5,:));
                    case(6)
                        im(i,j,:)=uint8(map(6,:));
                    case(7)
                        im(i,j,:)=uint8(map(7,:));
                end
            end
        end
        
 case 'new'
%         map=[0 0 255;255 100 0;0 255 134;150 70 150; 100 150 255;60 90 114;255 255 125;255 0 255;100 0 255;1 170 255;0 255 0;175 175 82;100 190 56;140 67 46;115 255 172;255 255 0];
            map=[0 100 0;  0 150 0;  0 200 0;  0 255 0;  255 240 0;  0 0 255;  255 255 255;  200 200 200;  255 190 0;  255 190 0;  255 130 0;  170 170 170;  80 170 170;  0 20 0;  173 168 190];
        for i=1:w
            for j=1:h
                switch(label(i,j))
                    case(1)
                        im(i,j,:)=uint8(map(1,:));
                    case(2)
                        im(i,j,:)=uint8(map(2,:));
                    case(3)
                        im(i,j,:)=uint8(map(3,:));
                    case(4)
                        im(i,j,:)=uint8(map(4,:));
                    case(5)
                        im(i,j,:)=uint8(map(5,:));
                    case(6)
                        im(i,j,:)=uint8(map(6,:));
                    case(7)
                        im(i,j,:)=uint8(map(7,:));
                    case(8)
                        im(i,j,:)=uint8(map(8,:));
                    case(9)
                        im(i,j,:)=uint8(map(9,:));
                    case(10)
                        im(i,j,:)=uint8(map(10,:));
                    case(11)
                        im(i,j,:)=uint8(map(11,:));
                    case(12)
                        im(i,j,:)=uint8(map(12,:));
                    case(13)
                        im(i,j,:)=uint8(map(13,:));
                    case(14)
                        im(i,j,:)=uint8(map(14,:));   
                    case(15)
                        im(i,j,:)=uint8(map(15,:));     
                end
            end
        end
        
        case 'munich'
%           map=[0 100 0;  0 150 0;  0 200 0;  0 255 0;  255 240 0;  0 0 255;  255 255 255;  200 200 200;  255 190 0;  255 190 0;  255 130 0;  170 170 170;  80 170 170;  0 20 0;  173 168 190];
%         map=[0 0 255;255 100 0;0 255 134;150 70 150; 100 150 255;60 90 114;255 255 125;255 0 255;100 0 255;1 170 255;0 255 0;175 175 82;100 190 56;140 67 46;115 255 172;255 255 0];
          map=[0 255 0; 0 100 0; 255 240 0; 192 192 192;  255 130 0; 255 0 0; 128 0 128; 165 82 41;0,0,255;10 10 10;0 255 255]; 
          % 1 tree; 2 grass; 3 soil; 4 road; 5 shadow 6 running track 
          % 7 Tile roof 8 Tar roof 9 Concrete roof 
          % 10 metal1 roof 11 metal2 roof 
          
          for i = 1:11
              ind = label == i;
              im = im + cat(3,ind.*map(i,1),ind.*map(i,2),ind.*map(i,3));
          end
         
          
            
%         for i=1:w
%             for j=1:h
%                 switch(label(i,j))
%                     case(1)
%                         im(i,j,:)=uint8(map(1,:));
%                     case(2)
%                         im(i,j,:)=uint8(map(2,:));
%                     case(3)
%                         im(i,j,:)=uint8(map(3,:));
%                     case(4)
%                         im(i,j,:)=uint8(map(4,:));
%                     case(5)
%                         im(i,j,:)=uint8(map(5,:));
%                     case(6)
%                         im(i,j,:)=uint8(map(6,:)); 
%                     case(7)
%                         im(i,j,:)=uint8(map(7,:));
%                     case(8)
%                         im(i,j,:)=uint8(map(8,:));
%                     case(9)
%                         im(i,j,:)=uint8(map(9,:)); 
%                 end
%             end
%         end


        case 'flevoland'
%           map=[0 100 0;  0 150 0;  0 200 0;  0 255 0;  255 240 0;  0 0 255;  255 255 255;  200 200 200;  255 190 0;  255 190 0;  255 130 0;  170 170 170;  80 170 170;  0 20 0;  173 168 190];
%         map=[0 0 255;255 100 0;0 255 134;150 70 150; 100 150 255;60 90 114;255 255 125;255 0 255;100 0 255;1 170 255;0 255 0;175 175 82;100 190 56;140 67 46;115 255 172;255 255 0];
          map=[
              102 0 204;        % 1. stembeans
              0 150 0;          % 2. Peas
              0 50  0;          % 3. Forest
              255 51 153;       % 4. Lucerne
              0 255 255;        % 5. Wheat
              255 130 0;        % 6. Beet
              255 0 0;          % 7. Potatoes
              255 240 0;        % 8. Bare soil
              165 82 41;        % 9. Grasses
              128 0 128;        % 10. Rapeseed
              128 0 10;         % 11. Barley
              0 255 150;        % 12. Wheat 2
              0 255 50;         % 13. Wheat 3
              0,0,255;          % 14. Water
              192 192 192;      % 15. Building
              ]; 
                    
          for i = 1:15
              ind = label == i;
              im = im + cat(3,ind.*map(i,1),ind.*map(i,2),ind.*map(i,3));
          end
          
    case 'lcz'
        
        map=[
          % % R     G       B                      COLOR       NAME        DESCRIPTION         MINIMUM             MAXIMUM
             165,   0,       33;               % % 140         "1"         "compHR"            1.000000            1.000000
             204,   0,        0;               % % 209         "2"         "compMR"            2.000000            2.000000
             255,   0,        0;               % % 255         "3"         "compLR"            3.000000            3.000000
             153,   51,       0;               % % 19903       "4"         "openHR"            4.000000            4.000000
             204,   102,      0;               % % 26367       "5"         "openMR"            5.000000            5.000000
             255,   153,      0;               % % 5609983     "6"         "openLR"            6.000000            6.000000
             255,   255,      0;               % % 388858      "7"         "light"             7.000000            7.000000
             192,   192,    192;               % % 12369084    "8"         "largeLow"          8.000000            8.000000
             255,   204,    153;               % % 11193599    "9"         "sparse"            9.000000            9.000000
              77,    77,     77;               % % 5592405     "10"        "industr"           10.000000           10.000000    
               0,   102,      0;               % % 27136       "A"         "denseTree"         101.000000          101.000000
              21,   255,     21;               % % 43520       "B"         "scatTree"          102.000000          102.000000
             102,   153,      0;               % % 2458980     "C"         "bush"              103.000000          103.000000
             204,   255,    102;               % % 7986105     "D"         "lowPlant"          104.000000          104.000000
               0,     0,    102;               % % 0           "E"         "paved"             105.000000          105.000000
             255,   255,    204;               % % 11466747    "F"         "soil"              106.000000          106.000000
              51,   102,    255;               % % 16738922    "G"         "water"             107.000000          107.000000
              ]; 
        idx = [1,2,3,4,5,6,7,8,9,10,101,102,103,104,105,106,107];
        for i = 1:17
            ind = label == idx(i);
            im = im + cat(3,ind.*map(i,1),ind.*map(i,2),ind.*map(i,3));
        end
        for i = 11:17
            ind = label == i;
            im = im + cat(3,ind.*map(i,1),ind.*map(i,2),ind.*map(i,3));
        end
        
    case 'mumbaipolsarclusters'
        
        map=[
          % % R     G       B                      NAME        DESCRIPTION                                  MINIMUM             MAXIMUM
             153,   51,     255;               % % "1"         "NW_SE_orientated_purple"                    1.000000            1.000000
               0,   0,      122;               % % "2"         "NE_SW_orientated_blue"                      2.000000            2.000000
             200,   200,    200;               % % "3"         "trucks_containers_bright"                   3.000000            3.000000
             255,   255,    102;               % % "4"         "orientated_big_struture_yellow_bright"      4.000000            4.000000
             118,    89,      0;               % % "5"         "orientated_medium_struture_yellow"          5.000000            5.000000
              51,   102,    255;               % % "6"         "water"                                      6.000000            6.000000
             255,   255,    204;               % % "7"         "sands"                                      7.000000            7.000000
             155,     0,      0;               % % "8"         "dis_orientated_yellow"                      8.000000            8.000000
               0,   102,      0;               % % "9"         "vegetation"                                 9.000000            9.000000
             ]; 
        idx = [1,2,3,4,5,6,7,8,9];
        for i = 1:9
            ind = label == idx(i);
            im = im + cat(3,ind.*map(i,1),ind.*map(i,2),ind.*map(i,3));
        end
        
    case 'cnnmumbai'
        
        idx = [7201,7202,7203,7204,7205,7206,7207,7208,7209,7210,7211,7212,7213,7214,7215,7217,7218,8200,8201,8202,8203,8221];
        
        map=[
          % % R     G       B                  NAME        DESCRIPTION
             0,     100,      0;           % % "7201"      "forest"             
             162,   255,    126;           % % "7202"      "park"
             255,     0,      0;           % % "7203"      "residential"            important **
             255,   255,      0;           % % "7204"      "industrial"             important **
              10,   255,     10;           % % "7205"      "farm"
             217,   217,    217;           % % "7206"      "cemetery"                                   'mu di'
             255,     0,    255;           % % "7207"      "allotment"              few sample          'cai di'
             255,   192,    255;           % % "7208"      "meadow"                 few sample          'cao chang'
               0,   255,    255;           % % "7209"      "commercial"             important **
             112,    48,    160;           % % "7210"      "nature_reserve"                             'zi ran bao hu qu'
             250,   128,     18;           % % "7211"      "recreation_ground"                          'gong gong yu le chang di'
             250,   192,    144;           % % "7212"      "retail"                                     'ling shou'
              81,    81,     81;           % % "7213"      "military"
             127,   127,    127;           % % "7214"      "quarry"                                     'cai shi chang'
             215,   228,    189;           % % "7215"      "orchard"                few sample          'guo yuan'
                                           % % "7216"      "vineyard"               few sample
             119,   147,     60;           % % "7217"      "scrub"                                      'guan mu'
               0,   204,    153;           % % "7218"      "grass"
              51,   102,    255;           % % "8200"      "water"
             198,   217,    241;           % % "8201"      "reservoir"                                  'shui ku'
              85,   142,    213;           % % "8202"      "river"
             217,   150,    148;           % % "8203"      "dock"
               0,     0,    255;           % % "8221"      "wetland"
              ]; 
        
        for i = 1:length(idx)
            ind = label == idx(i);
            im = im + cat(3,ind.*map(i,1),ind.*map(i,2),ind.*map(i,3));
        end
        
    case 'houston2018'
        
        idx = 1:20;
        
        map=[
          % % R     G       B                  NAME        DESCRIPTION
             0,     100,      0;           % % "7201"      "forest"             
             162,   255,    126;           % % "7202"      "park"
             255,     0,      0;           % % "7203"      "residential"            important **
             255,   255,      0;           % % "7204"      "industrial"             important **
              10,   255,     10;           % % "7205"      "farm"
             217,   217,    217;           % % "7206"      "cemetery"                                   'mu di'
             255,     0,    255;           % % "7207"      "allotment"              few sample          'cai di'
             255,   192,    255;           % % "7208"      "meadow"                 few sample          'cao chang'
               0,   255,    255;           % % "7209"      "commercial"             important **
             112,    48,    160;           % % "7210"      "nature_reserve"                             'zi ran bao hu qu'
             250,   128,     18;           % % "7211"      "recreation_ground"                          'gong gong yu le chang di'
             250,   192,    144;           % % "7212"      "retail"                                     'ling shou'
              81,    81,     81;           % % "7213"      "military"
             127,   127,    127;           % % "7214"      "quarry"                                     'cai shi chang'
             215,   228,    189;           % % "7215"      "orchard"                few sample          'guo yuan'
                                           % % "7216"      "vineyard"               few sample
             119,   147,     60;           % % "7217"      "scrub"                                      'guan mu'
               0,   204,    153;           % % "7218"      "grass"
              51,   102,    255;           % % "8200"      "water"
             198,   217,    241;           % % "8201"      "reservoir"                                  'shui ku'
              85,   142,    213;           % % "8202"      "river"
             217,   150,    148;           % % "8203"      "dock"
               0,     0,    255;           % % "8221"      "wetland"
              ]; 
        
        for i = 1:length(idx)
            ind = label == idx(i);
            im = im + cat(3,ind.*map(i,1),ind.*map(i,2),ind.*map(i,3));
        end
        
    case 'chikusei'
        
        idx = 1:19;
        
        map=[
          %  R       G       B                  NAME        DESCRIPTION
            65,     105,    225;
            240,    230,    140;
            244,    164,    96;
            255,    255,    0;
            0,      139,    139;
            85,     107,    47;
            34,     139,    34;
            154,    205,    50;
            124,    252,    0;
            0,      255,    255;
            143,    188,    143;
            200,    200,    250;
            255,    255,    255;
            64,     64,     64;
            0,      0,      255;
            255,    0,      0;
            127,    255,    212;
            192,    192,    192;
            210,    180,    140
              ]; 
        
        for i = 1:length(idx)
            ind = label == idx(i);
            im = im + cat(3,ind.*map(i,1),ind.*map(i,2),ind.*map(i,3));
        end
        
end



name=sprintf('classif_%s.tif',data_name);
im=uint8(im);
classif=uint8(zeros(w,h,3));
classif(:,:,1)=im(:,:,1);
classif(:,:,2)=im(:,:,2);
classif(:,:,3)=im(:,:,3);
% imshow(im,[])
%imwrite(classif,name);