% function NotNormalized_Replaybackgr(savefolder, folderMain, folderReal, folderAttackf, folderAttackh, dLibFolder)
% savefolder = 'Nov30_Replaybackgr';
% 
% folderMain = '/media/ewa/SH/ReplayAttackDirectories/';
folderMain = '/media/ewa/SH/DatasetsAntiSpoof/3dmadDirectories/';

% folderReal = 'train/real/';
% folderAttackf = 'train/attack/fixed/';  % both contain photo, vid in adverse and controlled
% folderAttackh = 'train/attack/hand/';

savefolder = 'Sep26_3DMAD_bck'; % with gaussian filtering and saving the whole raw PPG matrix
mkdir(savefolder);
load('../highpass_05_30.mat')
load('../lowpass_5_30.mat')

addpath('/home/ewa/Dropbox (Rice Scalable Health)/DocumentsUbuntu/Liveness_Detection_Security/Code/BPADCameraVitals2016')
for f = 1:3
%     if f == 1
%         folderEnd = folderReal;
%     end
%     if f == 2
%         folderEnd = folderAttackf;
% 
%     end
%     if f == 3
%         folderEnd = folderAttackh;
%     end
    folderEnd = ['Data0' num2str(f) 'Keep/'];

    fileNameList = dir([[folderMain folderEnd] ['*' '.avi']]); %
    for i =1:length(fileNameList)
        imgCells{i} = fileNameList(i).name;  
    end
    [cs,index] = sort_nat(imgCells,'ascend');
    img_names = cs;
    
for m = 1:length(fileNameList)
try
            vidName = img_names{m};       
            % read in the videos
            v = VideoReader([folderMain folderEnd vidName]);
            videoLength = v.Duration;
            videoRate = v.FrameRate;
            numFrame = videoLength*videoRate;
            width = v.Width;
            height = v.Height; 

            frames = read(v);
            vg = frames(:,:,2,:);
            vg = permute(vg,[1,2,4,3]);
            firstFrame = vg(:,:,1);
%% face ROI
    load(['/media/ewa/Data/PreliminaryResultsToCleanUp/FromBPADCameraVitals2016/Data/3DMAD1stFrame/Data0' num2str(f) 'Dlib/dLib-' vidName(1:end-4) '_C.avi' '.png.mat'])
     firstPoints = pointsResized;
     %% define background ROI
     wmin = min(firstPoints(1:68,1));
     hmin = min(firstPoints(1:68,2));
     wmax = max(firstPoints(1:68,1));
     hmax = max(firstPoints(1:68,2)); 

     a1 = round(wmin - 75); % starting point
     a2 = round(hmin -25);
     aw = 50;
     ah = 50; 
      
     Ax = [a1 a1+50 a1+50 a1]; % left top
     Ay = [a2 a2 a2+50 a2+50];
     
      b1 = round(wmax + 50); % starting point
     b2 = round(hmax - 50);
     bw = 50;
     bh = 50; 
     
     Bx = [b1 b1+50 b1+50 b1]; % right bottom
     By = [b2 b2 b2+50 b2+50];
%% find background ROI
for t = 1:numFrame
    regionMaskA = roipoly(vg(:,:,t), Ax, Ay);
    RectA(:,:,t) = single(im2double(vg(:,:,t)).*(regionMaskA));
end

for t = 1:numFrame
    regionMaskB = roipoly(vg(:,:,t), Bx, By);
    RectB(:,:,t) = single(im2double(vg(:,:,t)).*(regionMaskB));
end
%% apply tracking and get pointsList out
rr = 8; % use 2 if normalizing face ROI, else 8
ROISizeGrid =rr;

first_frame = vg(:,:,1);
widthImg = size(first_frame, 1);
heightImg = size(first_frame, 2);

widthImg = size(first_frame, 1);
heightImg = size(first_frame, 2);
% set ROI
width = floor(widthImg/(ROISizeGrid/2));
height = floor(heightImg/(ROISizeGrid/2));
regionMaskA = RectA;
regionMaskB = RectB;
xmin = 1;
ymin =1;

% figure, imshow(regionMask)
% hold on
% initialize grid points, get each pixel within the ROI, counter should = w*h
counter = 0;
pointsList_initA = [];
for i = 1:width-1
    for j = 1:height-1
        pixelX = xmin + (i-1)*ROISizeGrid/2 + floor(ROISizeGrid/2);  %+ i;  
        pixelY = ymin + (j-1)*ROISizeGrid/2 + floor(ROISizeGrid/2); %+ j;
        if regionMaskA(pixelX,pixelY)
%             regionMask(pixelX,pixelY)
           counter = counter+1;

%             plot(pixelY, pixelX, 'r *')
% [pixelX, pixelY]
%             pause(2)

            pointsList_initA(counter, 1) = pixelY;
            pointsList_initA(counter, 2) = pixelX;
        end
    end
end
pointsListA = [];
for i = 1:numFrame
pointsListA = cat(3, pointsListA, pointsList_initA);
i = i+1;
end
pointsListA = permute(pointsListA, [3 1 2]);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%
counter = 0;
pointsList_initB = [];
for i = 1:width-1
    for j = 1:height-1
        pixelX = xmin + (i-1)*ROISizeGrid/2 + floor(ROISizeGrid/2);  %+ i;  
        pixelY = ymin + (j-1)*ROISizeGrid/2 + floor(ROISizeGrid/2); %+ j;
        if regionMaskB(pixelX,pixelY)
%             regionMask(pixelX,pixelY)
           counter = counter+1;

%             plot(pixelY, pixelX, 'r *')
% [pixelX, pixelY]
%             pause(2)

            pointsList_initB(counter, 1) = pixelY;
            pointsList_initB(counter, 2) = pixelX;
        end
    end
end
pointsListB = [];
for i = 1:numFrame
pointsListB = cat(3, pointsListB, pointsList_initB);
i = i+1;
end
pointsListB = permute(pointsListB, [3 1 2]);

%% smooth    
numFrame = size(vg,3);
Gauss_sigma = 2.5; % should be based on size of ROI?
vgSpatFiltA = zeros(size(vg,1), size(vg,2), floor(numFrame)); %zeros(240, 320,floor(numFrame));  
% filter on the whole frame because the shape of ROI is changing
for g = 1:numFrame-1
    nextFrame = RectA(:,:,g); % imresize(vg(:,:,g), [240 320]);
    spatFiltImg = imgaussfilt(nextFrame, Gauss_sigma);
%         figure, imshow(spatFiltImg)
    vgSpatFiltA(:,:,g) = spatFiltImg;
end 
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

numFrame = size(vg,3);
Gauss_sigma = 2.5; % should be based on size of ROI?
vgSpatFiltB = zeros(size(vg,1), size(vg,2), floor(numFrame)); %zeros(240, 320,floor(numFrame));  
% filter on the whole frame because the shape of ROI is changing
for g = 1:numFrame-1
    nextFrame = RectB(:,:,g); % imresize(vg(:,:,g), [240 320]);
    spatFiltImg = imgaussfilt(nextFrame, Gauss_sigma);
%         figure, imshow(spatFiltImg)
    vgSpatFiltB(:,:,g) = spatFiltImg;
end

%% get PPG
nn = 10; 
numFrame2 = size(pointsListA,1);
[PPGrawA] = getPPG(vgSpatFiltA(:,:,1:numFrame2), pointsListA, nn); %     PPGraw - no mean subtraction or temporal filtering
[PPGrawB] = getPPG(vgSpatFiltB(:,:,1:numFrame2), pointsListB, nn);

PPGrawA = double(PPGrawA);
PPGrawB = double(PPGrawB);
%% FFT
% subtract mean
clear PPGA
for c = 1:size(PPGrawA,2)
    PPGA(:,c) = PPGrawA(:,c) - mean(PPGrawA(:,c));
end

clear PPGB
for c = 1:size(PPGrawB,2)
    PPGB(:,c) = PPGrawB(:,c) - mean(PPGrawB(:,c));
end

%% bandpass filter
clear PPGraw2 
clear PPGAfilt
for c = 1:size(pointsListA,2)
        PPGraw1 = PPGA(:,c);  % with mean subtracted
        PPGraw2(:,c) = PPGraw1;
           PPG2filt0 =  PPGraw2(:,c);
           PPG2filt1 = filtfilt(lowpass_5,1,PPG2filt0);  %low pass
           PPG2filt2 = filtfilt(highpass_05,IIR_part,PPG2filt1); % high pass
           PPGAfilt(:,c) = PPG2filt2;
end

clear PPGraw2 
clear PPGBfilt
for c = 1:size(pointsListB,2)
        PPGraw1 = PPGB(:,c);  % with mean subtracted
        PPGraw2(:,c) = PPGraw1;
           PPG2filt0 =  PPGraw2(:,c);
           PPG2filt1 = filtfilt(lowpass_5,1,PPG2filt0);  %low pass
           PPG2filt2 = filtfilt(highpass_05,IIR_part,PPG2filt1); % high pass
           PPGBfilt(:,c) = PPG2filt2;
end

save([savefolder '/' num2str(f) '-'  num2str(m) '-' 'point.mat'], 'pointsListA', 'pointsListB')
save([savefolder '/' num2str(f) '-'  num2str(m) '-'  'PPGraw.mat'], 'PPGA', 'PPGB')
save([savefolder '/' num2str(f) '-'  num2str(m) '-'  'PPGfilt.mat'], 'PPGAfilt', 'PPGBfilt')


disp([num2str(f) '-'   num2str(m)])
    catch 
        continue
    end
    end 
 end

% end